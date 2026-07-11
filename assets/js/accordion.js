// Single-open Akkordion: Öffnen einer Klappe schließt jede andere.
// Wiederverwendet von Diskografie (.release.is-expandable) und Repertoire (.cat).
function initAccordion(groupSelector, headSelector, toggleSelector) {
  var items = document.querySelectorAll(groupSelector);
  items.forEach(function (item) {
    var head = item.querySelector(headSelector);
    if (!head) return;
    head.addEventListener('click', function (e) {
      if (e.target.closest('a')) return; // Links innerhalb des Headers (z. B. Streaming) nicht toggeln
      var willOpen = !item.classList.contains('is-open');
      items.forEach(function (other) {
        if (other !== item) {
          other.classList.remove('is-open');
          var ob = other.querySelector(toggleSelector);
          if (ob) ob.setAttribute('aria-expanded', 'false');
        }
      });
      item.classList.toggle('is-open', willOpen);
      var btn = item.querySelector(toggleSelector);
      if (btn) btn.setAttribute('aria-expanded', willOpen ? 'true' : 'false');
    });
  });
}
