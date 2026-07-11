(function () {
  var track = document.getElementById('track');
  if (!track) return;

  var quotes = document.querySelectorAll('.quote');
  var overlay = document.querySelector('.overlay');
  var total = track.children.length;
  var index = 0;

  function render() {
    track.style.transform = 'translateX(-' + (index * (100 / total)) + '%)';
    quotes.forEach(function (q) {
      q.classList.toggle('is-active', Number(q.dataset.slide) === index);
    });
    // Bild 1 (index 0) = heller Hintergrund -> dunkler Header; Bilder 2–4 -> heller Header
    overlay.classList.toggle('is-dark', index === 0);
  }
  function next() { index = (index + 1) % total; render(); }

  render();
  setInterval(next, 5000);
})();
