// Dotfiles friendly Firefox preferences
//
// Firefox reads this file at startup and applies each pref; it never writes
// back to it (docs: https://kb.mozillazine.org/User.js_file).
//
// To apply: symlink/copy into your profile dir (the folder containing
// prefs.js), then restart Firefox.

// ─── UI & Behavior ──────────────────────────────────────────────────────────
user_pref("browser.toolbars.bookmarks.visibility", "always"); // always show the bookmarks toolbar
user_pref("browser.startup.page", 3); // on launch, restore the previous session
user_pref("browser.ctrlTab.sortByRecentlyUsed", true); // Ctrl+Tab cycles tabs in most-recently-used order
user_pref("browser.urlbar.showSearchSuggestionsFirst", false); // list history/bookmarks before search suggestions in the address bar
user_pref("accessibility.typeaheadfind.flashBar", 0); // don't flash the find bar when quick-find has no match
user_pref("findbar.highlightAll", true); // highlight all matches by default in the find bar
user_pref("full-screen-api.ignore-widgets", true); // HTML5 fullscreen fills the window content area instead of taking over the whole screen
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); // load userChrome.css / userContent.css customizations

// ─── Sidebar & Vertical Tabs ────────────────────────────────────────────────
user_pref("sidebar.revamp", true); // use the new (revamped) sidebar UI
user_pref("sidebar.verticalTabs", true); // arrange tabs vertically in the sidebar (requires sidebar.revamp)

// ─── macOS Trackpad Gestures ────────────────────────────────────────────────
user_pref("browser.gesture.swipe.left", "cmd_scrollLeft"); // two-finger swipe left scrolls instead of navigating back
user_pref("browser.gesture.swipe.right", "cmd_scrollRight"); // two-finger swipe right scrolls instead of navigating forward

// ─── Privacy & Telemetry ────────────────────────────────────────────────────
user_pref("datareporting.healthreport.uploadEnabled", false); // don't send Firefox Health Report / technical data to Mozilla
user_pref("datareporting.usage.uploadEnabled", false); // don't send usage-profile telemetry to Mozilla
user_pref("app.shield.optoutstudies.enabled", false); // never enroll in Shield/normandy studies
user_pref("nimbus.rollouts.enabled", false); // opt out of Nimbus experiment rollouts
user_pref("browser.discovery.enabled", false); // disable add-on/feature recommendations ("discovery")
user_pref("beacon.enabled", false); // block the Navigator.sendBeacon() analytics API
user_pref("privacy.globalprivacycontrol.enabled", true); // send the Global Privacy Control signal to sites

// ─── Autofill & Passwords ───────────────────────────────────────────────────
user_pref("browser.formfill.enable", false); // don't remember form field history
user_pref("extensions.formautofill.addresses.enabled", false); // disable address autofill
user_pref("extensions.formautofill.creditCards.enabled", false); // disable credit-card autofill
user_pref("signon.rememberSignons", false); // don't offer to save logins/passwords
user_pref("signon.management.page.breach-alerts.enabled", false); // disable password breach alerts

// ─── Disable AI / ML Features ───────────────────────────────────────────────
user_pref("browser.ai.control.default", "blocked"); // block AI features by default
user_pref("browser.ai.control.linkPreviewKeyPoints", "blocked"); // block AI "key points" in link previews
user_pref("browser.ai.control.pdfjsAltText", "blocked"); // block AI-generated alt text in the PDF viewer
user_pref("browser.ai.control.sidebarChatbot", "blocked"); // block the sidebar AI chatbot
user_pref("browser.ai.control.smartTabGroups", "blocked"); // block AI-suggested "smart" tab groups
user_pref("browser.ai.control.translations", "blocked"); // block AI-assisted translations
user_pref("browser.ml.chat.enabled", false); // disable the AI chatbot feature entirely
user_pref("browser.ml.chat.page", false); // disable AI page summarization
user_pref("browser.ml.linkPreview.enabled", false); // disable ML-powered link previews
user_pref("extensions.ml.enabled", false); // disable on-device ML models for extensions
user_pref("browser.tabs.groups.smart.enabled", false); // disable AI smart tab grouping
user_pref("browser.tabs.groups.smart.userEnabled", false); // keep the smart-tab-group user toggle off
user_pref("browser.translations.enable", false); // disable the built-in translations feature
user_pref("extensions.pocket.enabled", false); // remove Pocket integration

// ─── DevTools ───────────────────────────────────────────────────────────────
user_pref("devtools.theme", "dark"); // dark theme for DevTools
user_pref("devtools.cache.disabled", true); // disable HTTP cache while DevTools is open
user_pref("devtools.chrome.enabled", true); // allow debugging browser chrome (Browser Toolbox / console)
user_pref("devtools.debugger.remote-enabled", true); // allow remote debugging connections
user_pref("devtools.browserconsole.input.editor", true); // use the multiline editor mode in the console
user_pref("devtools.inspector.three-pane-enabled", false); // use the two-pane inspector layout
user_pref("devtools.responsive.touchSimulation.enabled", true); // simulate touch events in Responsive Design Mode
user_pref("devtools.webconsole.filter.info", false); // hide "info" level messages in the console
user_pref("devtools.webconsole.filter.warn", false); // hide "warning" level messages in the console
