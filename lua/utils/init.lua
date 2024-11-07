local log = require('utils.log')

local M = {}

local is_underline_enabled = true
vim.diagnostic.config({ underline = is_underline_enabled })
M.toggle_diagnostic_underline = function()
  is_underline_enabled = not is_underline_enabled
  vim.diagnostic.config({ underline = is_underline_enabled })
end

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

M.close_octo_buffers = function()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    local buf_name = vim.api.nvim_buf_get_name(buf)

    if buf_name:match('^octo://') and vim.api.nvim_get_option_value('modified', { buf = buf }) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

M.toggle_option = function(option_name)
  local buf = vim.api.nvim_get_current_buf()
  local value = vim.api.nvim_buf_get_option(buf, option_name)
  vim.api.nvim_buf_set_option(buf, option_name, not value)
end

return M
