// ==UserScript==
// @name         Terraform Cloud Workspace Title
// @namespace    https://github.com/zkhvan
// @version      1.0
// @description  Set page title to workspace name on Terraform Cloud workspace pages
// @match        https://app.terraform.io/app/*/workspaces/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function() {
  'use strict';

  function getWorkspaceName() {
    // Only match main workspace page, not subpages like /runs, /variables
    const match = window.location.pathname.match(/\/app\/[^/]+\/workspaces\/([^/]+)\/?$/);
    return match ? decodeURIComponent(match[1]) : null;
  }

  function setTitle() {
    const workspaceName = getWorkspaceName();
    if (workspaceName && document.title !== workspaceName) {
      document.title = workspaceName;
    }
  }

  // Keep retrying until page settles, then watch for changes
  let retryCount = 0;
  const retry = setInterval(() => {
    setTitle();
    if (++retryCount >= 20) clearInterval(retry); // Stop after ~2s
  }, 100);

  // Re-apply whenever Terraform Cloud changes the title back
  new MutationObserver(setTitle).observe(
    document.querySelector('title') || document.head,
    { subtree: true, childList: true, characterData: true }
  );

  // Also handle SPA navigation
  let lastUrl = location.href;
  new MutationObserver(() => {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      retryCount = 0;
    }
  }).observe(document.body, { subtree: true, childList: true });
})();
