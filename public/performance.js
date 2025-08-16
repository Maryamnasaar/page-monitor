console.log("performance.js is running!");

window.addEventListener('load', () => {
  const navigation = performance.getEntriesByType('navigation')[0];

  const domReadyTime = Number(navigation.domContentLoadedEventEnd - navigation.startTime);
  const loadTime     = Number(navigation.loadEventEnd - navigation.startTime);
  const pageUrl      = window.location.href;
  const pageSize     = Number(navigation.decodedBodySize);

  console.log('Performance timings:', { domReadyTime, loadTime, pageSize });
  console.log(navigation);

  // Send immediately after load (optional)
  fetch('/perf/page', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      pageUrl: pageUrl,
      pageSize: pageSize,
      domReady: domReadyTime,
      loadTime: loadTime
    })
  })
  .then(r => r.json())
  .then(data => console.log("Server response:", data))
  .catch(err => console.error("Failed to send data:", err));

  // Send again when leaving the page (guaranteed delivery)
  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "hidden") {
      const payload = new Blob(
        [JSON.stringify({
          pageUrl: pageUrl,
          pageSize: pageSize,
          domReady: domReadyTime,
          loadTime: loadTime
        })],
        { type: 'application/json' }
      );
      navigator.sendBeacon('/perf/page', payload);
    }
  });
});
