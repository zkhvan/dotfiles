// ==UserScript==
// @name         CircleCI Pipeline Title
// @namespace    https://github.com/zkhvan
// @version      1.0
// @description  Set CircleCI pipeline page title from branch/filter URL params
// @match        https://app.circleci.com/pipelines/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function() {
 'use strict';

 const FILTER_TITLES = {
   mine: 'mine',
   all: 'all',
 };

 function getPipelineTitle() {
   // Match main CircleCI pipelines page:
   // /pipelines/<vcs>/<org-or-id>/<project-or-id>
   const isPipelinePage = /^\/pipelines\/[^/]+\/[^/]+\/[^/]+\/?$/.test(
     window.location.pathname
   );

   if (!isPipelinePage) return null;

   const params = new URLSearchParams(window.location.search);

   const branch = params.get('branch');
   const filter = params.get('filter') || 'all';

   const parts = [];

   if (branch) {
     parts.push(branch);
   }

   if (filter && FILTER_TITLES[filter]) {
     parts.push(FILTER_TITLES[filter]);
   }

   return `${parts.join(' · ')} | CircleCI`;
 }

 function setTitle() {
   const title = getPipelineTitle();

   if (title && document.title !== title) {
     document.title = title;
   }
 }

 function retrySetTitle() {
   let retryCount = 0;

   const retry = setInterval(() => {
     setTitle();

     if (++retryCount >= 20) {
       clearInterval(retry);
     }
   }, 100);
 }

 retrySetTitle();

 // Re-apply whenever CircleCI changes the title back
 new MutationObserver(setTitle).observe(
   document.querySelector('title') || document.head,
   { subtree: true, childList: true, characterData: true }
 );

 // Handle SPA navigation / query param changes
 let lastUrl = location.href;

 function onUrlChange() {
   if (location.href !== lastUrl) {
     lastUrl = location.href;
     retrySetTitle();
   }
 }

 new MutationObserver(onUrlChange).observe(document.body, {
   subtree: true,
   childList: true,
 });

 window.addEventListener('popstate', onUrlChange);

 const originalPushState = history.pushState;
 history.pushState = function() {
   originalPushState.apply(this, arguments);
   onUrlChange();
 };

 const originalReplaceState = history.replaceState;
 history.replaceState = function() {
   originalReplaceState.apply(this, arguments);
   onUrlChange();
 };
})();
