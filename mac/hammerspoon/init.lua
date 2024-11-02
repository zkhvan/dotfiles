-- ---------------------------------------------------------------------------
-- init.lua
-- ---------------------------------------------------------------------------

print('======================================================================')

hs.autoLaunch(true)
hs.consoleOnTop(false)
hs.dockIcon(false)
hs.menuIcon(true)

hyper = { '⌘', '⌃', '⇧' }
althyper = { '⌘', '⌃', '⇧', 'alt' }

local mods = {}
table.insert(mods, require('clipboard.type'))
-- table.insert(mods, require("launcher.seal"))
-- table.insert(mods, require("launcher.apps"))
table.insert(mods, require('menubar.caffeine'))
table.insert(mods, require('window.gridy'))
table.insert(mods, require('window.throw'))
table.insert(mods, require('window.split'))

-- hs.loadSpoon('HCalendar')

-- Regenerate lua annotations
-- hs.loadSpoon("EmmyLua")

print('== reload')
hs.hotkey.bind(hyper, '0', function()
  for _, mod in ipairs(mods) do
    if type(mod) == 'table' and mod['destructor'] then
      print('== destroying ' .. mod['name'])
      mod['destructor']()
    end
  end
  hs.notify.show('Reloading Hammerspoon config', 'Manually', '')
  print('reloading...')
  hs.reload()
end)
