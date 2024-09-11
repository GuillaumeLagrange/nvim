vim.cmd('cnoreabbrev octo Octo')

return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  dev = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    picker = 'telescope',
    use_local_fs = true,
    enable_builtin = true,
    reviews = {
      auto_show_threads = false,
    },
    mappings_disable_default = true,
    ui = {
      use_signcolumn = true,
    },
  },
  keys = {
    {
      '<leader>op',
      function()
        require('utils').close_octo_buffers()
        vim.api.nvim_command('Octo pr')
      end,
      mode = 'n',
      desc = 'Open PR for current branch',
    },
    { '<leader>oy', '<cmd>Octo pr url<CR>', mode = 'n', desc = 'Yank PR url' },
    { '<leader>oa', '<cmd>Octo comment add<CR>', mode = { 'n', 'v' }, desc = 'Add comment' },
    { '<leader>ot', '<cmd>Octo review thread<CR>', 'n', desc = 'show_review_threads' },
  },
}
