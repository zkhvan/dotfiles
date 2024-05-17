local M = {}

M.pipelines = {}

function M.register(options)
  if options.filetype == nil then
    return
  end

  M.pipelines[options.filetype] = options.pipeline
end

return M
