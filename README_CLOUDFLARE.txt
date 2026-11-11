CAMINOS DE FE — ODYSSEY 3D V12
PAQUETE PARA CLOUDFLARE PAGES
================================

ARCHIVO PRINCIPAL
- index.html

OTROS ARCHIVOS
- JUGAR_Caminos_de_Fe_Odyssey3D_V12_MotionHD.html : copia con el nombre largo original.
- _headers : encabezados básicos de seguridad y control de caché.
- _redirects : permite abrir /, /jugar o /game.
- wrangler.toml : configuración opcional para Wrangler / Cloudflare Pages.
- source/V12_original.html : respaldo exacto del juego antes de empaquetarlo.
- docs/DEPENDENCIAS.txt : explica qué se carga externamente.

COMO SUBIRLO CON CLOUDFLARE PAGES (DRAG & DROP)
1. Descomprime este ZIP.
2. En Cloudflare, entra a Workers & Pages / Pages.
3. Crea un proyecto mediante Direct Upload / Upload assets.
4. Sube EL CONTENIDO de esta carpeta o la carpeta completa según la interfaz.
5. Confirma que index.html quede en la raíz del despliegue.
6. Publica.
7. Abre la URL *.pages.dev que te entregue Cloudflare.

NO NECESITA PHP, WORDPRESS, BASE DE DATOS NI NODE PARA EJECUTARSE.
Es un sitio estático.

IMPORTANTE SOBRE EL MOTOR 3D
Esta versión todavía carga Three.js 0.181.2 y sus módulos de postprocesado desde jsDelivr.
Eso es normal y funcionará desde Cloudflare Pages mientras haya conexión a internet.
El juego contiene sus texturas procedurales, lógica, preguntas, misiones y UI dentro del HTML.
Las imágenes y enlaces de JW/WOL permanecen apuntando a sus sitios de origen.

PARA PROBAR CORRECTAMENTE
No abras index.html con file:// después de desplegarlo. Usa la URL HTTPS de Cloudflare Pages.
El alojamiento HTTPS evita varios problemas típicos de módulos ES, caché y recursos externos.
