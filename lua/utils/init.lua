local M = {}

M.toggle_inlay_hints = function(bufnr)
  if vim.lsp.inlay_hint.is_enabled(bufnr) then
    vim.lsp.inlay_hint.enable(bufnr, false)
  else
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

M.toggle_relative_number = function()
  if vim.opt_local.relativenumber:get() then
    vim.opt_local.relativenumber = false
  else
    vim.opt_local.relativenumber = true
  end
end

return M
