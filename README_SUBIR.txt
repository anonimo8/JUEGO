CAMINOS DE FE — V12.6 BUNDLED — CLOUDFLARE WORKERS

ESTA VERSION NO USA CDN NI PROXY PARA THREE.JS.
Three.js y sus addons se empaquetan dentro de dist/game.bundle.js durante npm install.

ESTRUCTURA QUE DEBE QUEDAR EN LA RAIZ DEL REPO:
  package.json
  wrangler.toml
  scripts/build.mjs
  source/game-entry.js
  source/index.template.html

CONFIGURACION CLOUDFLARE:
  Build command: Ninguno
  Deploy command: npx wrangler deploy
  Root directory: /

El paso Installing ejecuta npm install. El postinstall ejecuta npm run build y crea dist/.
Luego wrangler deploy publica dist/ como assets estaticos.

EN EL LOG DEBE APARECER:
  CDF-V12.6-BUNDLED
  Three.js + addons bundled into dist/game.bundle.js

DESPUES DE PUBLICAR:
  /build-id.txt -> CDF-V12.6-BUNDLED
  /health.json -> bundled:true, cdn:false, proxy:false
  / -> juego
