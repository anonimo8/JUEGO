CAMINOS DE FE V15 · LITE ADVENTURE

Esta versión reemplaza el modo 3D pesado como experiencia principal.

GITHUB / CLOUDFLARE
1. Reemplaza los archivos de la versión anterior por los de esta carpeta.
2. Cloudflare: Build command = npm run build
3. Deploy command = npx wrangler deploy
4. Root directory = /

No subas dist/: Cloudflare lo genera durante el build.

Verificación:
/build-id.txt debe mostrar CDF-V15-LITE-ADVENTURE
/health.json debe indicar mode=lite y three=false.
