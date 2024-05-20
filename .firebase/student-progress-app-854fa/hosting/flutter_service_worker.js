'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "4079ddf7d6fb27ae32344f2b68c5a738",
"/": "4079ddf7d6fb27ae32344f2b68c5a738",
"main.dart.js": "2c1f5703a9ffa9884c5bc0474627a81c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"version.json": "86fd9c36fc5ffd39dd40090f961ea8c2",
"manifest.json": "4d804e018746b4936147ada96b567536",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "61c622424de2850337c4ccb58b91e7de",
"assets/packages/awesome_notifications/test/assets/images/test_image.png": "c27a71ab4008c83eba9b554775aa12ca",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/AssetManifest.json": "d237f57f0506d1bc2644ac90b1791652",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "24a4cf322b3e94ad4151358036ab237d",
"assets/NOTICES": "0cfeadacc6b81cc97744bad68266a1bf",
"assets/AssetManifest.bin.json": "bd76b911dff35c06005842435bcc0132",
"assets/assets/icons/Vector-3.png": "a845850ab3cedba08e6cad2aac5433ab",
"assets/assets/icons/fire_overall.png": "bafb399f3385c9b163defcf39cc8a0b1",
"assets/assets/icons/Vector-1.png": "f73757849c0db91d9df17ee721f6dfbb",
"assets/assets/icons/chemistry_icon.png": "914683988f0b4606c684ae89472cea55",
"assets/assets/icons/Vector-2.png": "db841ebff7e73f2d939bd1fc2a4ec4ac",
"assets/assets/icons/paper_writing.png": "96826a3b4c7c83410398cb1e3d993292",
"assets/assets/icons/agriculture_icon.png": "3972b850f4e260ecea4a797d883375b1",
"assets/assets/icons/google.png": "7e557f1c0864829c54c300d15bee69f4",
"assets/assets/icons/804e4cd1-6099-4025-8241-979877b72572.jpg": "2cdb29e2f30f697b236b2c9453eec215",
"assets/assets/icons/physics_icon.png": "d10dc135b51a57008f5c905fc6922e80",
"assets/assets/icons/app_icon.png": "406886fae045a41da3b483783c937ed6",
"assets/assets/icons/Vector.png": "7895e9729a3cdf0b91049b36c7025924",
"assets/assets/video/1.mp4": "d9061d3da8601932e98f79ec8ba1c877",
"assets/assets/images/student_marks_background.png": "1bd190dc1b938b713943edd1e176cade",
"assets/assets/images/home_background.png": "7863f0f1f28940a290fc635b494ddb34",
"assets/assets/images/cs.gif": "9f139c795bf1add9961736c301360af3",
"assets/assets/images/login_background.gif": "a24848b630272d2fb448dc1d22e6dfb5",
"assets/assets/images/subjectImage.png": "e43dc770744f8283a04bc0f8896f7f26",
"assets/assets/images/signup_background.png": "e79abcad6730ec604da92c7013eda2fd",
"assets/assets/images/Untitledvideo-MadewithClipchamp1-ezgif.com-crop.gif": "b645534454ac594648065469cd4229e4",
"assets/assets/images/login_background.png": "e79abcad6730ec604da92c7013eda2fd",
"assets/assets/animation/paper.gif": "0bdf4a118b578877c5e3a64661f43448",
"assets/assets/animation/greet.gif": "548f999132258554c53ae32a79efda18",
"assets/assets/animation/study.png": "1d0238795f909b3304cdfa862bfad0d5",
"assets/assets/animation/study.gif": "582eeb4e629c42f7e70ad8762a09057f",
"assets/FontManifest.json": "7df10702a8c60a62e6694f43081d46e7",
"assets/fonts/MaterialIcons-Regular.otf": "d6d2c524fb4f3101c1010c3081647f92",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
