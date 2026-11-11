import { cp, mkdir, rm, access, copyFile } from 'node:fs/promises';
import { constants } from 'node:fs';
import { resolve, join } from 'node:path';

const root = resolve(process.cwd());
const src = join(root, 'node_modules', 'three');
const dest = join(root, 'public', 'vendor', 'three');

async function mustExist(path) {
  try { await access(path, constants.R_OK); }
  catch { throw new Error(`No se encontró Three.js en ${path}. Verifica que npm haya instalado dependencies.`); }
}

await mustExist(join(src, 'build', 'three.module.js'));
await mustExist(join(src, 'examples', 'jsm'));
await rm(dest, { recursive: true, force: true });
await mkdir(dest, { recursive: true });
await cp(join(src, 'build'), join(dest, 'build'), { recursive: true });
await cp(join(src, 'examples', 'jsm'), join(dest, 'examples', 'jsm'), { recursive: true });
try { await copyFile(join(src, 'LICENSE'), join(dest, 'LICENSE')); } catch {}
console.log('✓ Three.js self-hosted copiado a public/vendor/three');
console.log('✓ Runtime sin CDN: /vendor/three/build/three.module.js');
