# ANLEITUNG — Webseite Denise Stanojev

Alles liegt in diesem Ordner (`informes/webseite/`). Zum Anschauen einfach **`index.html` doppelklicken** — läuft in jedem Browser, ohne Internet, ohne Installation.

## 📁 Ordner

```
webseite/
├── index.html            ← die ganze Seite (Design + Logik eingebaut)
└── assets/
    ├── bilder/           ← alle Fotos hier rein
    └── videos/           ← alle Videodateien hier rein
```

## 🖼️ Bilder einsetzen

1. Foto in `assets/bilder/` legen, Name z. B. `01.jpg`.
2. In `index.html` den Namen beim jeweiligen `<img src="assets/bilder/01.jpg">` anpassen.

**Empfohlene Namen, damit nichts getauscht werden muss:**

| Datei | Wo es erscheint | Format |
|---|---|---|
| `hero.jpg` | Großes Hintergrundbild oben | quer, min. 1600 px breit |
| `01.jpg` … `06.jpg` | Galerie (6 Felder) | quadratisch, min. 1000×1000 |
| `video1.jpg` … `video3.jpg` | Vorschaubilder der Videokarten | 16:9 |

Fehlt ein Bild, zeigt die Seite automatisch einen sauberen Platzhalter — nichts wirkt kaputt.

## 🎬 Video-Hintergrund oben (optional)

1. Video nach `assets/videos/hero.mp4` (kurz halten: 10–20 s, stumm, unter ~5 MB).
2. In `index.html` im Bereich `<div class="hero">` die beiden Kommentarzeilen mit `<video class="bgvideo"…>` einkommentieren.

## ▶️ Video-Karten (YouTube / TikTok / eigene Datei)

Im Abschnitt `id="videos"`:

- **YouTube:** `data-embed="https://www.youtube.com/embed/VIDEO_ID"` beim `vbox` eintragen.
  Das Video wird erst beim Klick geladen → Seite bleibt schnell und es werden vorher keine Daten an YouTube gesendet.
- **Eigene Datei:** statt `vbox` ein `<video controls poster="assets/bilder/video1.jpg"><source src="assets/videos/kampf1.mp4"></video>` einsetzen.

## ✍️ Texte austauschen

Alle offenen Stellen sind sichtbar orange markiert: `[Platzhalter]`. Danach Suche-und-Ersetzen oder mir schicken — ich fülle es ein.

## ⚖️ Rechte (wichtig)

Nur Bilder/Videos veröffentlichen, für die die **Nutzungsrechte vorliegen**. Pressefotos (z. B. Harry Hirsch Sportfotograf) gehören dem Fotografen — Nutzung schriftlich klären oder eigene Fotos verwenden. Namen von Fotografen können als Bildnachweis eingetragen werden.

## 🚀 Später ins Internet stellen

Statische Seite → passt zu: Netlify, Vercel, Cloudflare Pages, GitHub Pages (alle mit Gratis-Stufe) oder klassisches Webhosting per FTP. Zusätzlich nötig: Domain + **Impressum** und **Datenschutzerklärung** (in Österreich Pflicht).
