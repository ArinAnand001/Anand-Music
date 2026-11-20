// Anand service worker: keeps the app itself available with no internet.
// Songs are not cached here; they live in the app's on-device storage (IndexedDB).
const APP_CACHE = 'mixtape-app-v2';
const FONT_CACHE = 'mixtape-fonts-v1';
const APP_FILES = [
  './',
  './index.html',
  './config.js',
  './manifest.webmanifest',
  './icons/icon-192.png',
  './icons/icon-512.png',
  './icons/maskable-512.png',
  './icons/apple-touch-icon.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(APP_CACHE).then(cache => cache.addAll(APP_FILES)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== APP_CACHE && k !== FONT_CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// Serve from cache first so the app opens instantly offline, then refresh the cache in the background.
function cacheFirst(event, cacheName, fallbackUrl) {
  const req = event.request;
  return caches.open(cacheName).then(async cache => {
    const cached = await cache.match(req, { ignoreSearch: true }) ||
      (fallbackUrl ? await cache.match(fallbackUrl) : undefined);
    const network = fetch(req).then(res => {
      if (res && (res.ok || res.type === 'opaque')) cache.put(req, res.clone());
      return res;
    }).catch(() => undefined);
    if (cached) {
      event.waitUntil(network);
      return cached;
    }
    const res = await network;
    return res || (fallbackUrl && await cache.match(fallbackUrl)) || Response.error();
  });
}

self.addEventListener('fetch', event => {
  const req = event.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin === self.location.origin) {
    event.respondWith(cacheFirst(event, APP_CACHE, req.mode === 'navigate' ? './index.html' : undefined));
  } else if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
    event.respondWith(cacheFirst(event, FONT_CACHE));
  }
});
