local M = {}

--- Checks if the string ends with the suffix.
--- @param str string The string to check.
--- @param suffix string The suffix to check for.
function M.endswith(str, suffix)
  return suffix == '' or str:sub(-#suffix) == suffix
end

--- Checks if the string ends with any of the suffixes
--- @param str string The string to check.
--- @param suffixes string[] The set of suffixes to check for.
function M.endswithany(str, suffixes)
  for _, suffix in ipairs(suffixes) do
    if M.endswith(str, suffix) then
      return true
    end
  end

  return false
end

return M
