import { mkdir, readFile, writeFile, rm } from 'node:fs/promises';
const BUILD='CDF-V15-LITE-ADVENTURE';
await rm('dist',{recursive:true,force:true}); await mkdir('dist',{recursive:true});
const html=await readFile('source/index.template.html','utf8'); const js=await readFile('source/game-entry.js','utf8');
await writeFile('dist/index.html',html); await writeFile('dist/game.js',js); await writeFile('dist/build-id.txt',BUILD+'\n');
await writeFile('dist/health.json',JSON.stringify({build:BUILD,mode:'lite',three:false,mobile:true},null,2));
console.log('✓ '+BUILD); console.log('✓ Lightweight: no Three.js / no WebGL'); console.log('✓ Mobile-first scenes + character cards + touch drag/drop');