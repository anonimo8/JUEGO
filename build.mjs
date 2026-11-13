import { existsSync, rmSync, cpSync, statSync } from 'node:fs';
import { join } from 'node:path';

const source = 'public';
const target = 'dist';
if (!existsSync(join(source, 'index.html'))) {
  throw new Error('Falta public/index.html: revisa que hayas copiado toda la carpeta del sitio.');
}
if (!existsSync(join(source, 'game-v25.js'))) {
  throw new Error('Falta public/game-v25.js.');
}
rmSync(target, { recursive: true, force: true });
cpSync(source, target, { recursive: true });
if (!existsSync(join(target, 'index.html')) || !statSync(join(target, 'index.html')).isFile()) {
  throw new Error('No se generó dist/index.html.');
}
console.log('Caminos de Fe V25.1 preparado para Cloudflare Pages en dist/.');
