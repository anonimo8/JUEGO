# Caminos de Fe V25.1 · Cloudflare Pages

Este paquete es para un repositorio GitHub/GitLab conectado a **Cloudflare Pages**.

1. Sube el **contenido de esta carpeta** a la raíz del repositorio (debe verse `package.json` junto a `public/`).
2. En Cloudflare Pages > Settings > Builds & deployments, configura:
   - Framework preset: **None**.
   - Root directory: **/** (raíz del repositorio).
   - Build command: `npm run build`
   - Build output directory: `dist`
3. Guarda los cambios y vuelve a desplegar.

El proyecto no usa dependencias npm: el build simplemente copia todos los archivos estáticos de `public/` a `dist/`.

## Alternativa sin compilación

Sube el contenido de `public/` directamente a tu repositorio y configura **Build command vacío** (o `exit 0`) y **Build output directory `.`**.

## Importante

Este paquete publica solo los archivos del juego web. No incluye scripts `.cmd` o `.ps1` de descarga personal, ni imágenes descargadas localmente desde JW.org. Estas últimas NO se suben al sitio público. La carpeta `assets/escenas-v20` contiene únicamente los fondos alternativos del juego previo.

Para comprobar el paquete en tu equipo, desde esta carpeta ejecuta `npm run build` y verifica que se cree `dist/index.html`.
