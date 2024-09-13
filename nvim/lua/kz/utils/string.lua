local M = {}

--- Checks if the string ends with the specified suffix.
---@param str string
---@param suffix string
M.endswith = function(str, suffix)
  return suffix == "" or str:sub(-#suffix) == suffix
end

M.endswithany = function(str, suffixes)
  for _, suffix in ipairs(suffixes) do
    if M.endswith(str, suffix) then
      return true
    end
  end

  return false
end

M.capitalize = function(str)
  return (str:gsub('^%l', string.upper))
end

---@param haystack string
---@param needle string
---@return boolean found true if needle in haystack
M.starts_with = function(haystack, needle)
  return type(haystack) == 'string' and haystack:sub(1, needle:len()) == needle
end

-- alt F ғ (ghayn)
-- alt Q ꞯ (currently using ogonek)
local smallcaps =
  'ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ‹›⁰¹²³⁴⁵⁶⁷⁸⁹'
local normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ<>0123456789'

---@param text string
M.smallcaps = function(text)
  return vim.fn.tr(text:upper(), normal, smallcaps)
end

return M
