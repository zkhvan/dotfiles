local tools = require('kz.tools')

tools.servers['lua_ls'] = {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
    },
  },
}
