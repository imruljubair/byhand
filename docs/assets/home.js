(() => {
  const copyButton = document.querySelector("[data-copy-button]");
  const command = document.querySelector("[data-copy-command] code");
  if (!copyButton || !command) return;

  const originalLabel = copyButton.textContent;
  let resetTimer;

  copyButton.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(command.textContent);
      copyButton.textContent = "Copied";
      copyButton.setAttribute("aria-label", "Commands copied");
      window.clearTimeout(resetTimer);
      resetTimer = window.setTimeout(() => {
        copyButton.textContent = originalLabel;
        copyButton.setAttribute(
          "aria-label",
          "Copy installation and example commands",
        );
      }, 1800);
    } catch {
      copyButton.textContent = "Select and copy";
    }
  });
})();
