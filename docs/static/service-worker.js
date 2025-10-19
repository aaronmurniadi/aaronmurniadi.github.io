// Service worker for caching font files with infinite cache lifetime
const CACHE_NAME = 'font-cache-v1';
const FONT_FILES = [
  '/static/mvc-roman.otf.woff2',
  '/static/mvc-italic.otf.woff2'
];

// Install event - cache font files
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(FONT_FILES);
      })
      .then(() => self.skipWaiting())
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.filter(cacheName => {
          return cacheName !== CACHE_NAME;
        }).map(cacheName => {
          return caches.delete(cacheName);
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch event - serve from cache if available
self.addEventListener('fetch', event => {
  // Only handle font requests
  const url = new URL(event.request.url);
  if (FONT_FILES.some(fontFile => url.pathname.endsWith(fontFile.split('/').pop()))) {
    event.respondWith(
      caches.match(event.request)
        .then(response => {
          if (response) {
            // Return cached font file
            return response;
          }
          
          // If not in cache, fetch it
          return fetch(event.request).then(response => {
            // Clone the response as it can only be consumed once
            const responseToCache = response.clone();
            
            // Open cache and store the fetched font
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            
            return response;
          });
        })
    );
  }
});
