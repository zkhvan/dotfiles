---
-- Generic app keybinds

print "== launcher.apps"

-- C is for caffeine

hs.hotkey.bind(hyper, 'g', function()
  hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, 'i', function()
  hs.application.launchOrFocus("iTerm")
end)

hs.hotkey.bind(hyper, 's', function()
  hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind(hyper, 'z', function()
  hs.toggleConsole()
end)

return nil
