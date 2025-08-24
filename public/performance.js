console.log("performance.js is running!");

window.addEventListener('load', () => {
  if (window.__perfLogged) return; // prevent multiple sends
  window.__perfLogged = true;

  const [navigation] = performance.getEntriesByType('navigation');
  const pageUrl = window.location.href;
  const pageSize = navigation.decodedBodySize;
  const domReadyTime = navigation.domContentLoadedEventEnd - navigation.startTime;
  const time = performance.timeOrigin;

  // Wait a tiny moment to ensure loadEventEnd is populated
  setTimeout(() => {
    const loadTime = navigation.loadEventEnd;

    console.log('Performance timings:', { domReadyTime, loadTime, pageSize });
    console.log(navigation);

    const payload = {
      pageUrl,
      pageSize,
      domReady: domReadyTime,
      loadTime,
      time
    };

    // Send immediately
    fetch('/perf/page', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })
    .then(r => r.json())
    .then(data => console.log("Server response:", data))
    .catch(err => console.error("Failed to send data:", err));

    // Send again on page unload
    document.addEventListener("visibilitychange", () => {
      if (document.visibilityState === "hidden") {
        const blob = new Blob([JSON.stringify(payload)], { type: 'application/json' });
        navigator.sendBeacon('/perf/page', blob);
      }
    });

  }, 0); // ensures loadEventEnd is populated
});

