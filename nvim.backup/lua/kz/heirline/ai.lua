return {
  condition = function()
    return require('lazy.core.config').plugins['windsurf.nvim']._.loaded
  end,
  provider = function()
    return require('codeium.virtual_text').status_string()
  end,
  hl = 'dkoStatusKey',
}
