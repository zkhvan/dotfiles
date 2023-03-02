hs.grid.setGrid('10.75x12', '3440x1440');

hs.hotkey.bind(hyper, "pad1", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 3, 6, 9), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad4", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 0, 5, 12), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad7", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 0, 6, 6), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad8", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(4, 0, 4, 6), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad5", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(2, 0, 6, 12), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad2", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(2, 3, 6, 9), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad9", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(6, 0, 6, 6), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad6", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(8, 3, 3, 9), '3440x1440')
end)

hs.hotkey.bind(hyper, "pad3", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(6, 3, 5, 9), '3440x1440')
end)

-- For when sharing screen
hs.hotkey.bind(althyper, "pad1", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 8, 3, 4), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad4", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 3, 3, 9), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad7", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 3, 3, 5), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad2", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 8, 6, 4), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad5", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(1, 4, 4, 7), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad8", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(0, 3, 6, 5), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad3", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(3, 8, 3, 4), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad6", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(3, 3, 3, 9), '3440x1440')
end)

hs.hotkey.bind(althyper, "pad9", function()
  local window = hs.window.focusedWindow()
  hs.grid.set(window, hs.geometry(3, 3, 3, 5), '3440x1440')
end)
