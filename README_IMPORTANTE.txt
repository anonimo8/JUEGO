ESTRUCTURA ÚNICA PARA GITHUB/CLOUDFLARE

NO debe existir worker.js en la raíz.
NO debe existir public/.
NO mezclar archivos de V12.4, V12.5, V12.7.

Cloudflare:
Build command: npm run build
Deploy command: npx wrangler deploy
Root directory: /

El build genera dist/ con index.html, game.bundle.js, build-id.txt y health.json.
