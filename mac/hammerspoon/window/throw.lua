---
-- Move windows across screens
print "== window.throw"

hs.hotkey.bind(hyper, ']', function()
  local window = hs.window.focusedWindow()
  if (window:isFullScreen()) then
    window:setFullScreen(false)
    --window:moveOneScreenEast()
    hs.grid.pushWindowNextScreen(window);
    hs.timer.doAfter(0.6, function()
      window:setFullScreen(true)
    end)
  else
    -- window:moveOneScreenEast()
    hs.grid.pushWindowNextScreen(window);
  end
end)

hs.hotkey.bind(hyper, '[', function()
  local window = hs.window.focusedWindow()
  if (window:isFullScreen()) then
    window:setFullScreen(false)
    -- window:moveOneScreenWest()
    hs.grid.pushWindowNextScreen(window);
    hs.timer.doAfter(0.6, function()
      window:setFullScreen(true)
    end)
  else
    -- window.moveOneScreenWest()
    hs.grid.pushWindowNextScreen(window);
  end
end)

return nil
