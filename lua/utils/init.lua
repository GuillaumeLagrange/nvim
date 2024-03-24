local log = require('utils.log')

local M = {}

M.toggle_inlay_hints = function(bufnr)
  if vim.lsp.inlay_hint.is_enabled(bufnr) then
    vim.lsp.inlay_hint.enable(bufnr, false)
  else
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

M.toggle_relative_number = function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt_local.relativenumber:get() then
    vim.opt_local.relativenumber = false
    log.info('Enabled relativenumber', { title = 'Diagnostics' })
  else
    vim.opt_local.relativenumber = true
    log.info('Disabled relativenumber', { title = 'Diagnostics' })
  end
end

M.toggle_diagnostics = function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    log.info('Enabled diagnostics', { title = 'Diagnostics' })
  else
    vim.diagnostic.disable()
    log.info('Disabled diagnostics', { title = 'Diagnostics' })
  end
end

return M
