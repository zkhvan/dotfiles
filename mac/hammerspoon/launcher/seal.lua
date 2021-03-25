---
-- App launcher
-- http://www.hammerspoon.org/Spoons/Seal.html
print "== launcher"

hs.loadSpoon("Seal")

spoon.Seal:loadPlugins({ "calc", "apps", "useractions" })
spoon.Seal:bindHotkeys({
  show = {{"cmd"}, "Space"}
})
spoon.Seal.plugins.useractions.actions = {
  ["Open chrome profile"] = {
    keyword = "c",
    fn = function(profile)
      if profile == "" then profile = "Personal"
      elseif profile == "w" then profile = "Work"
      else profile = "Personal"
      end

      local launchChromeProfileScript =
        'do shell script ' ..
        '"/Applications/Google\\\\ Chrome.app/Contents/MacOS/Google\\\\ Chrome' ..
        ' --profile-directory=' ..
        profile ..
        ' --new-window > /dev/null 2>&1 &"'

      hs.osascript.applescript(launchChromeProfileScript)
    end,
  }
}
spoon.Seal:start()

local seal = {
  name = "seal"
}
function seal.destructor()
  spoon.Seal:refreshAllCommands()
end
return seal
