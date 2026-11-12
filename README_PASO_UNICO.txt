CAMINOS DE FE V12.7 — CORRECCION DIRECTA EN CLOUDFLARE

OBJETIVO: eliminar GitHub/build/assets de la prueba.

1. Cloudflare > Workers & Pages > nx > Editar código.
2. Borra TODO el código que aparezca en el editor.
3. Abre worker.js de este paquete, copia TODO y pégalo.
4. Pulsa Deploy/Implementar.
5. Abre /build-id.txt. Debe decir: CDF-V12.7-DIRECT-EDITOR
6. Abre /vendor-check. Debe mostrar STATUS=200 y BYTES grande.
7. Abre /.

Si /build-id.txt no dice V12.7, estás abriendo otro Worker/dominio.
Si /vendor-check da 502, la pantalla mostrará el upstream exacto que falla.

Esta versión NO depende del repositorio conectado para esta prueba.
