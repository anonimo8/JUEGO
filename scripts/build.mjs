import { build } from 'esbuild';
import { mkdir, rm, copyFile, writeFile, readFile } from 'node:fs/promises';
const BUILD='CDF-V13.1-AGILE-MOTION';
await rm('dist',{recursive:true,force:true});
await mkdir('dist',{recursive:true});
await build({
  entryPoints:['source/game-entry.js'],
  bundle:true,
  outfile:'dist/game.bundle.js',
  format:'iife',
  platform:'browser',
  target:['es2020'],
  minify:true,
  sourcemap:false,
  legalComments:'none',
  define:{'process.env.NODE_ENV':'"production"'},
  logLevel:'info'
});
await copyFile('source/index.template.html','dist/index.html');
await writeFile('dist/build-id.txt',BUILD+'\n','utf8');
await writeFile('dist/health.json',JSON.stringify({build:BUILD,bundled:true,cdn:false,proxy:false,three:'0.181.2'},null,2)+'\n','utf8');
const bundle=await readFile('dist/game.bundle.js','utf8');
if (/cdn\.jsdelivr|unpkg\.com|import\(['\"]three/.test(bundle)) throw new Error('Runtime bundle still contains external THREE loading');
console.log('\\n✓ '+BUILD);
console.log('✓ Three.js + addons bundled into dist/game.bundle.js');
console.log('✓ No browser CDN, no proxy, no runtime import map');
console.log('✓ dist/index.html + build-id.txt generated\\n');
