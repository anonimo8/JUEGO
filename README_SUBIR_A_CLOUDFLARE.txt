CAMINOS DE FE — CLOUDFLARE V12.3 SELF-HOSTED

OBJETIVO
- El navegador NO usa jsDelivr ni otro CDN para Three.js.
- Cloudflare instala `three@0.181.2` durante la fase "Instalando".
- El script `postinstall` copia el motor dentro de `public/vendor/three/`.
- `npx wrangler deploy` publica esos archivos como assets del mismo dominio.

ESTRUCTURA EN LA RAIZ DEL REPOSITORIO
/
  package.json
  wrangler.toml
  scripts/vendor-three.mjs
  public/index.html
  public/diagnostico.html
  public/build-id.txt
  public/JUGAR_Caminos_de_Fe_Odyssey3D_V12_MotionHD.html

CONFIGURACION DE CLOUDFLARE
Build command: Ninguno
Deploy command: npx wrangler deploy
Root directory: /

IMPORTANTE
1. Extrae el ZIP.
2. Sube EL CONTENIDO del ZIP a la raiz de animo8/JUEGO (no el ZIP, no una carpeta contenedora adicional).
3. Haz commit a main.
4. La nueva compilacion debe mostrar que npm instala `three` y ejecutar:
   > caminos-de-fe-cloudflare-self-hosted@12.3.0 postinstall
   > node scripts/vendor-three.mjs
   ✓ Three.js self-hosted copiado a public/vendor/three
5. Cuando termine, abre:
   https://TU-DOMINIO/build-id.txt
   Debe decir: CDF-V12.3-SELF-HOSTED
6. Luego abre:
   https://TU-DOMINIO/diagnostico.html
   Debe mostrar: MOTOR 3D LOCAL CARGADO CORRECTAMENTE
7. Finalmente abre la raiz del sitio.

SI SIGUE APARECIENDO EL MENSAJE ANTIGUO "Esta versión necesita conexión..."
- No estas viendo esta V12.3.
- Verifica /build-id.txt.
- Haz Ctrl+Shift+R o abre una ventana Incognito.
- Confirma que la implementacion de Cloudflare corresponde al ultimo commit.
