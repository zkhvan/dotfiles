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

hs.hotkey.bind(hyper, 't', function()
  hs.application.launchOrFocus("Microsoft Teams")
end)

hs.hotkey.bind(hyper, 'w', function()
  hs.application.launchOrFocus("TR-W6073763")
end)

hs.hotkey.bind(hyper, 'r', function()
  hs.application.launchOrFocus("Rider")
end)

return nil
