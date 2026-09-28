#!/usr/bin/env bash
# Deploy-Skript: legt (falls nötig) das GitHub-Repo an, pusht die Seite und aktiviert GitHub Pages.
# Verwendung:  GH_TOKEN=<token> bash deploy.sh
# Der Token wird NICHT gespeichert, nur einmalig verwendet.

set -uo pipefail

: "${GH_TOKEN:?Bitte GH_TOKEN setzen}"

OWNER="zlatko1981"
REPO="denise-stanojev-website"
API="https://api.github.com"
BRANCH="main"
AUTH=(-H "Authorization: Bearer $GH_TOKEN" -H "Accept: application/vnd.github+json")
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "== 1) Zugang prüfen =="
me=$(curl -s "${AUTH[@]}" "$API/user" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('login') or d.get('message'))")
echo "   Account: $me"
[ "$me" = "$OWNER" ] || { echo "   FEHLER: Token gehört nicht zu $OWNER"; exit 1; }

echo "== 2) Repo prüfen/anlegen =="
code=$(curl -s -o /tmp/deploy_repo.json -w "%{http_code}" "${AUTH[@]}" "$API/repos/$OWNER/$REPO")
if [ "$code" = "404" ]; then
  code=$(curl -s -o /tmp/deploy_repo.json -w "%{http_code}" -X POST "${AUTH[@]}" "$API/user/repos" \
    -d "{\"name\":\"$REPO\",\"description\":\"Website fuer Denise Stanojev - Profiboxerin (Superfedergewicht, Wien)\",\"private\":false,\"has_issues\":true,\"has_wiki\":false,\"has_projects\":false,\"auto_init\":false}")
  echo "   Repo angelegt: HTTP $code"
else
  echo "   Repo existiert bereits: HTTP $code"
fi
[ "$code" = "200" ] || [ "$code" = "201" ] || { echo "   FEHLER: $code"; head -c 300 /tmp/deploy_repo.json; exit 1; }

echo "== 3) Dateien committen und pushen =="
cd "$DIR"
git init -q -b "$BRANCH" 2>/dev/null || true
git config user.name "$OWNER"
git config user.email "$OWNER@users.noreply.github.com"
git add -A
git commit -q -m "Website Denise Stanojev" 2>/dev/null && echo "   Commit erstellt" || echo "   Nichts zu committen"
# Token nur für diesen einen Push verwenden (nicht in .git/config speichern!)
if git push -q "https://x-access-token:$GH_TOKEN@github.com/$OWNER/$REPO.git" "HEAD:refs/heads/$BRANCH" --force; then
  echo "   Push OK"
else
  echo "   FEHLER: Push fehlgeschlagen (Contents: Read and write fehlt?)"; exit 1
fi

echo "== 4) GitHub Pages aktivieren =="
code=$(curl -s -o /tmp/deploy_pages.json -w "%{http_code}" -X POST "${AUTH[@]}" \
  "$API/repos/$OWNER/$REPO/pages" -d "{\"source\":{\"branch\":\"$BRANCH\",\"path\":\"/\"}}")
if [ "$code" = "201" ] || [ "$code" = "409" ]; then
  echo "   Pages: HTTP $code (201=neu aktiviert, 409=war schon aktiv)"
elif [ "$code" = "403" ]; then
  echo "   Pages: HTTP 403 -> Token-Recht 'Pages: Read and write' fehlt."
  echo "   Manuell: Repo -> Settings -> Pages -> Source: 'Deploy from a branch' -> main / (root) -> Save"
else
  echo "   Pages: HTTP $code"; head -c 300 /tmp/deploy_pages.json
fi

echo
echo "== FERTIG =="
echo "Repo:  https://github.com/$OWNER/$REPO"
echo "Seite: https://$OWNER.github.io/$REPO/   (erste Veröffentlichung dauert 1-2 Minuten)"
