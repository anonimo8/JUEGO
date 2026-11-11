const THREE_VERSION = '0.181.2';
const THREE_PREFIX = '/vendor/three/';

function bad(message, status = 400) {
  return new Response(message, {
    status,
    headers: { 'content-type': 'text/plain; charset=utf-8' },
  });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname.startsWith(THREE_PREFIX)) {
      if (request.method !== 'GET' && request.method !== 'HEAD') {
        return bad('Method not allowed', 405);
      }

      const relativePath = url.pathname.slice(THREE_PREFIX.length);
      if (!relativePath || relativePath.includes('..') || !/^[A-Za-z0-9_./-]+$/.test(relativePath)) {
        return bad('Invalid vendor path');
      }

      const upstreamUrl = `https://cdn.jsdelivr.net/npm/three@${THREE_VERSION}/${relativePath}`;
      const upstream = await fetch(upstreamUrl, {
        method: request.method,
        headers: {
          'Accept': request.headers.get('Accept') || '*/*',
          'User-Agent': 'Caminos-de-Fe-Cloudflare-Proxy/1.0',
        },
        cf: {
          cacheEverything: true,
          cacheTtl: 604800,
        },
      });

      if (!upstream.ok) {
        return bad(`Three.js upstream error ${upstream.status}: ${relativePath}`, 502);
      }

      const headers = new Headers(upstream.headers);
      headers.set('cache-control', 'public, max-age=604800, immutable');
      headers.set('access-control-allow-origin', '*');
      headers.set('x-cdf-three-proxy', THREE_VERSION);
      if (relativePath.endsWith('.js') && !headers.get('content-type')?.includes('javascript')) {
        headers.set('content-type', 'application/javascript; charset=utf-8');
      }

      return new Response(upstream.body, {
        status: 200,
        headers,
      });
    }

    return env.ASSETS.fetch(request);
  },
};
