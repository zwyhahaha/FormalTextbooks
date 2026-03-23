window.MathJax = {
  loader: {
    load: ["[tex]/ams", "[tex]/noerrors", "[tex]/noundefined"],
  },
  tex: {
    packages: { "[+]": ["ams", "noerrors", "noundefined"] },
    inlineMath: [["\\(", "\\)"], ["$", "$"]],
    displayMath: [["\\[", "\\]"], ["$$", "$$"]],
    processEscapes: true,
    processEnvironments: true,
    macros: {
      R: "{\\mathbb{R}}",
      E: "{\\mathbb{E}}",
      cX: "{\\mathcal{X}}",
      cY: "{\\mathcal{Y}}",
      cK: "{\\mathcal{K}}",
      cR: "{\\mathcal{R}}",
      cF: "{\\mathcal{F}}",
      cE: "{\\mathcal{E}}",
      mA: "{\\mathbb{A}}",
      mB: "{\\mathbb{B}}",
      mK: "{\\mathbb{K}}",
      mN: "{\\mathbb{N}}",
      mP: "{\\mathbb{P}}",
      mQ: "{\\mathbb{Q}}",
      mX: "{\\mathbb{X}}",
      argmin: "\\operatorname*{arg\\,min}",
      Tr: "\\operatorname{Tr}",
      logdet: "\\operatorname{logdet}",
    },
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex",
  },
};

function refreshMathJax() {
  if (!window.MathJax || !window.MathJax.typesetPromise) {
    return;
  }
  window.MathJax.typesetClear?.();
  window.MathJax.typesetPromise().catch((error) => console.error("MathJax typeset failed", error));
}

document.addEventListener("DOMContentLoaded", refreshMathJax);

if (typeof document$ !== "undefined" && document$.subscribe) {
  document$.subscribe(refreshMathJax);
}
