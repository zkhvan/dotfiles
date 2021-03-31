---
-- disable animation
hs.window.animationDuration = 0

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 10
hs.grid.GRIDHEIGHT = 10

-- Maximize window
hs.hotkey.bind(hyper, "F", function()
  hs.grid.maximizeWindow(hs.window.focusedWindow())
end)

-- Shift window on grid
hs.hotkey.bind({"ctrl", "alt"}, "left", function()
    hs.grid.pushWindowLeft(hs.window.focusedWindow())
end)
hs.hotkey.bind({"ctrl", "alt"}, "down", function()
    hs.grid.pushWindowDown(hs.window.focusedWindow())
end)
hs.hotkey.bind({"ctrl", "alt"}, "up", function()
    hs.grid.pushWindowUp(hs.window.focusedWindow())
end)
hs.hotkey.bind({"ctrl", "alt"}, "right", function()
    hs.grid.pushWindowRight(hs.window.focusedWindow())
end)

-- Resize window on grid
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "left", function()
    hs.grid.resizeWindowThinner(hs.window.focusedWindow())
end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "up", function()
    hs.grid.resizeWindowShorter(hs.window.focusedWindow())
end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "down", function()
    hs.grid.resizeWindowTaller(hs.window.focusedWindow())
end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "right", function()
    hs.grid.resizeWindowWider(hs.window.focusedWindow())
end)

return nil
