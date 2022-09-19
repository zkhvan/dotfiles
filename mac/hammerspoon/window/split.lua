---
-- Split windows
print "== window.split"

-- A unit rect which will make a window occupy the top 25% of a screen
hs.layout.top25 = hs.geometry.rect(0, 0, 1, 0.25)

-- A unit rect which will make a window occupy the top 33% of a screen
hs.layout.top33 = hs.geometry.rect(0, 0, 1, 0.33)

-- A unit rect which will make a window occupy the top 50% of a screen
hs.layout.top50 = hs.geometry.rect(0, 0, 1, 0.5)

-- A unit rect which will make a window occupy the top 67% of a screen
hs.layout.top67 = hs.geometry.rect(0, 0, 1, 0.67)

-- A unit rect which will make a window occupy the top 75% of a screen
hs.layout.top75 = hs.geometry.rect(0, 0, 1, 0.75)

-- A unit rect which will make a window occupy the bottom 25% of a screen
hs.layout.bottom25 = hs.geometry.rect(0, 0.75, 1, 0.25)

-- A unit rect which will make a window occupy the bottom 33% of a screen
hs.layout.bottom33 = hs.geometry.rect(0, 0.67, 1, 0.33)

-- A unit rect which will make a window occupy the bottom 50% of a screen
hs.layout.bottom50 = hs.geometry.rect(0, 0.5, 1, 0.5)

-- A unit rect which will make a window occupy the bottom 67% of a screen
hs.layout.bottom67 = hs.geometry.rect(0, 0.33, 1, 0.67)

-- A unit rect which will make a window occupy the bottom 75% of a screen
hs.layout.bottom75 = hs.geometry.rect(0, 0.25, 1, 0.75)

-- A unit rect which will make a window occupy the left 33% of a screen
hs.layout.left33 = hs.geometry.rect(0, 0, 0.33, 1)

-- A unit rect which will make a window occupy the left 67% of a screen
hs.layout.left67 = hs.geometry.rect(0, 0, 0.67, 1)

-- A unit rect which will make a window occupy the right 33% of a screen
hs.layout.right33 = hs.geometry.rect(0.67, 0, 0.33, 1)

-- A unit rect which will make a window occupy the right 67% of a screen
hs.layout.right67 = hs.geometry.rect(0.33, 0, 0.67, 1)

local movewindows = hs.hotkey.modal.new()

local function getAllWindows()
  local windows = hs.fnutils.map(hs.window.allWindows(), function(win)
    if win ~= hs.window.focusedWindow() then
      return {
        text = win:title(),
        subText = win:application():title(),
        image = hs.image.imageFromAppBundle(win:application():bundleID()),
        id = win:id()
      }
    end
  end)

  return windows
end

local function getWindowsOnScreen(focusedWindow)
  local filter = hs.window.filter.new()
  filter:setScreens(focusedWindow:screen():id())

  local windows = hs.fnutils.map(filter:getWindows(), function(win)
    if win ~= hs.window.focusedWindow() then
      return {
        text = win:title(),
        subText = win:application():title(),
        image = hs.image.imageFromAppBundle(win:application():bundleID()),
        id = win:id()
      }
    end
  end)

  return windows
end

hs.hotkey.bind(hyper, "m", function()
  movewindows:enter()
end)

movewindows:bind('', 'v', function()
  local windows = getWindowsOnScreen(hs.window.focusedWindow())

  local chooser = hs.chooser.new(function(choice)
    if choice ~= nil then
      local focused = hs.window.focusedWindow()
      local toRead  = hs.window.find(choice.id)
      if hs.eventtap.checkKeyboardModifiers()['alt'] then
        local frame = focused:frame()

        focused:setFrame(hs.layout.left67:fromUnitRect(frame))
        toRead:setFrame(hs.layout.right33:fromUnitRect(frame))
      else
        local frame = focused:frame()

        focused:setFrame(hs.layout.left50:fromUnitRect(frame))
        toRead:setFrame(hs.layout.right50:fromUnitRect(frame))
      end
      toRead:raise()
    end
  end)

  chooser
    :placeholderText("Choose window for 50/50 split. Hold ⎇ for 67/33.")
    :searchSubText(true)
    :choices(windows)
    :show()

  movewindows:exit()
end)

movewindows:bind('', 's', function()
  local windows = getWindowsOnScreen(hs.window.focusedWindow())

  local chooser = hs.chooser.new(function(choice)
    if choice ~= nil then
      local focused = hs.window.focusedWindow()
      local toRead  = hs.window.find(choice.id)
      if hs.eventtap.checkKeyboardModifiers()['alt'] then
        local frame = focused:frame()

        focused:setFrame(hs.layout.top67:fromUnitRect(frame))
        toRead:setFrame(hs.layout.bottom33:fromUnitRect(frame))
      else
        local frame = focused:frame()

        focused:setFrame(hs.layout.top50:fromUnitRect(frame))
        toRead:setFrame(hs.layout.bottom50:fromUnitRect(frame))
      end
      toRead:raise()
    end
  end)

  chooser
    :placeholderText("Choose window for 50/50 split. Hold ⎇ for 67/33.")
    :searchSubText(true)
    :choices(windows)
    :show()

  movewindows:exit()
end)

movewindows:bind('', 'w', function()
  local windows = getAllWindows()

  local chooser = hs.chooser.new(function(choice)
    if choice ~= nil then
      local focused = hs.window.focusedWindow()
      local selected = hs.window.find(choice.id)

      local focusedFrame = focused:frame()
      local selectedFrame = selected:frame()

      focused:setFrame(selectedFrame)
      selected:setFrame(focusedFrame)

      selected:raise()
    end
  end)

  chooser
    :placeholderText("Choose window to swap with")
    :searchSubText(true)
    :choices(windows)
    :show()

  movewindows:exit()
end)

movewindows:bind('', 'o', function()
  local windows = getAllWindows()

  local chooser = hs.chooser.new(function(choice)
    if choice ~= nil then
      local window  = hs.window.find(choice.id)

      window:focus()
    end
  end)

  chooser
    :placeholderText("Choose window to open")
    :searchSubText(true)
    :choices(windows)
    :show()

  movewindows:exit()
end)

