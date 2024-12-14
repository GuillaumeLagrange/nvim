return {
  'github/copilot.vim',
  lazy = false,
  init = function()
    vim.keymap.set('i', '<M-w>', '<Plug>(copilot-accept-word)', { desc = 'Accept copilot word' })
    vim.keymap.set('i', '<M-l>', '<Plug>(copilot-accept-line)', { desc = 'Accept copilot line' })
    vim.keymap.set('n', '<leader>uc', function()
      if vim.b.copilot_enabled == nil or vim.b.copilot_enabled then
        vim.b.copilot_enabled = false
      else
        vim.b.copilot_enabled = true
      end
    end, { desc = 'Toggle Copilot' })
  end,
}
