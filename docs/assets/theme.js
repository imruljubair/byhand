(() => {
  const storageKey = "byhand-theme";
  const root = document.documentElement;
  const systemTheme = window.matchMedia("(prefers-color-scheme: dark)");

  const readPreference = () => {
    try {
      const value = window.localStorage.getItem(storageKey);
      return value === "light" || value === "dark" ? value : null;
    } catch {
      return null;
    }
  };

  let preference = readPreference();

  const activeTheme = () =>
    preference || (systemTheme.matches ? "dark" : "light");

  const updateToggle = (theme) => {
    const toggle = document.querySelector(".theme-toggle");
    if (!toggle) return;

    const nextTheme = theme === "dark" ? "light" : "dark";
    toggle.setAttribute("aria-label", `Switch to ${nextTheme} theme`);
    toggle.setAttribute("title", `Switch to ${nextTheme} theme`);
    toggle.querySelector("span").textContent = theme === "dark" ? "☀" : "☾";
  };

  const applyTheme = (theme) => {
    root.dataset.theme = theme;
    updateToggle(theme);
  };

  applyTheme(activeTheme());

  document.addEventListener("DOMContentLoaded", () => {
    const toggle = document.querySelector(".theme-toggle");
    if (!toggle) return;

    updateToggle(activeTheme());
    toggle.addEventListener("click", () => {
      preference = activeTheme() === "dark" ? "light" : "dark";
      try {
        window.localStorage.setItem(storageKey, preference);
      } catch {
        // The selected theme still applies for the current page.
      }
      applyTheme(preference);
    });
  });

  systemTheme.addEventListener("change", () => {
    if (!preference) applyTheme(activeTheme());
  });
})();
