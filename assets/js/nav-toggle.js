(function () {
  var toggle = document.querySelector(".nav-toggle");
  var nav = document.getElementById("site-nav");
  if (!toggle || !nav) return;

  function isOpen() {
    return nav.classList.contains("is-open");
  }

  function open() {
    nav.classList.add("is-open");
    toggle.setAttribute("aria-expanded", "true");
  }

  function close() {
    nav.classList.remove("is-open");
    toggle.setAttribute("aria-expanded", "false");
  }

  toggle.addEventListener("click", function () {
    if (isOpen()) {
      close();
    } else {
      open();
    }
  });

  nav.addEventListener("click", function (event) {
    if (event.target.closest("a")) {
      close();
    }
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && isOpen()) {
      close();
      toggle.focus();
    }
  });

  window.addEventListener("resize", function () {
    if (window.innerWidth > 760 && isOpen()) {
      close();
    }
  });
})();
