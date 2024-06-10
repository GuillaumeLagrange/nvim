local log = require('utils.log')

local M = {}

M.toggle_inlay_hints = function(bufnr)
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr }), { bufnr })
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
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

M.get_git_root = function()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  if dot_git_path == '' then
    return vim.fn.expand('~')
  end
  return vim.fn.fnamemodify(dot_git_path, ':h')
end

return M
