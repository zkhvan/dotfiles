return {
  condition = function()
    return require('lazy.core.config').plugins['windsurf.vim']._.loaded
  end,
  provider = function()
    local status = vim.api.nvim_call_function('codeium#GetStatusString', {})
    return (' %s '):format(status)
  end,
  hl = 'dkoStatusKey',
}
