---
-- disable animation
hs.window.animationDuration = 0

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

hs.grid.setGrid('10x10', 'Built%-in Retina Display');
hs.grid.setGrid('12x19.75', '3840x1600');
hs.grid.setGrid('10.75x18', '3440x1440');

-- Maximize window
hs.hotkey.bind(hyper, "F", function()
  hs.grid.maximizeWindow(hs.window.focusedWindow())
end)

hs.hotkey.bind(hyper, "pad1", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 6, 6, 14), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad4", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 0, 4, 20), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad7", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 0, 6, 6), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad8", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(4, 0, 4, 6), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad5", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(4, 0, 4, 20), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad2", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(3, 6, 6, 14), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad9", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(6, 0, 6, 6), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad6", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(9, 6, 3, 14), '3840x1600')
end)

hs.hotkey.bind(hyper, "pad3", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(6, 6, 6, 14), '3840x1600')
end)

-- For when sharing screen
hs.hotkey.bind(althyper, "pad1", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 13, 3, 7), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad4", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 6, 3, 14), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad7", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 6, 3, 7), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad2", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 13, 6, 7), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad5", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(1, 8, 4, 10), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad8", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 6, 6, 7), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad1", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 13, 3, 7), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad3", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(3, 13, 3, 7), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad6", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(3, 6, 3, 14), '3840x1600')
end)

hs.hotkey.bind(althyper, "pad9", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(3, 6, 3, 7), '3840x1600')
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
