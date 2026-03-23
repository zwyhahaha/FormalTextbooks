document.addEventListener("DOMContentLoaded", () => {
  const filterRoots = document.querySelectorAll("[data-filter-root]");
  if (!filterRoots.length) {
    return;
  }

  const rows = Array.from(document.querySelectorAll("tr")).filter((row) =>
    row.querySelector("[data-status]")
  );

  filterRoots.forEach((root) => {
    const buttons = root.querySelectorAll("[data-filter-status]");
    buttons.forEach((button) => {
      button.addEventListener("click", () => {
        const selected = button.getAttribute("data-filter-status");
        buttons.forEach((candidate) => candidate.classList.remove("active"));
        button.classList.add("active");

        rows.forEach((row) => {
          const statusNode = row.querySelector("[data-status]");
          const status = statusNode ? statusNode.getAttribute("data-status") : "all";
          const hide = selected !== "all" && status !== selected;
          row.classList.toggle("is-hidden-by-filter", hide);
        });
      });
    });
  });
});
