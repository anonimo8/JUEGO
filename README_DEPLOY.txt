CAMINOS DE FE — CLOUDFLARE WORKER STATIC ASSETS (FIXED)
========================================================

ESTE PAQUETE ES PARA EL PROYECTO CLOUDFLARE "nx" QUE USA `wrangler deploy`.

CAUSA DEL ERROR ANTERIOR
------------------------
El paquete anterior usaba `pages_build_output_dir = "."`, que corresponde a Cloudflare Pages.
Tu compilación actual está usando `wrangler deploy` (Workers). En Workers, Wrangler necesita
un script `main` O un directorio de assets configurado con `[assets]`.

CONFIGURACIÓN CORREGIDA
-----------------------
wrangler.toml contiene:

name = "nx"
compatibility_date = "2026-11-11"

[assets]
directory = "./public"
html_handling = "auto-trailing-slash"
not_found_handling = "single-page-application"

NO necesitas `main = "src/index.ts"` porque este proyecto es un sitio estático.

ESTRUCTURA
----------
/
  wrangler.toml
  package.json
  public/
    index.html
    JUGAR_Caminos_de_Fe_Odyssey3D_V12_MotionHD.html

SI USAS GIT / CLOUDFLARE BUILDS
-------------------------------
1. Coloca TODO el contenido de esta carpeta en la raíz del repositorio.
2. Build command: déjalo como `npx wrangler deploy` si Cloudflare ya lo configuró así.
3. No uses Output directory en el dashboard para este Worker; Wrangler toma `./public` de wrangler.toml.
4. Vuelve a desplegar.

SI QUIERES CLOUDLFARE PAGES EN VEZ DE WORKERS
---------------------------------------------
Crea un proyecto Pages nuevo y usa `public` como Build output directory. No mezcles la
configuración Pages (`pages_build_output_dir`) con un deployment de Workers (`wrangler deploy`).

NOTA
----
Las rutas desconocidas sirven index.html mediante `not_found_handling = "single-page-application"`.
