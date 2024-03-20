return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Git status' })
      vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = 'Git blame' })
      vim.keymap.set('n', '<leader>gr', '<cmd>Gread<cr>', { desc = 'Read buffer' })
      vim.keymap.set('n', '<leader>gw', '<cmd>Gwrite<cr>', { desc = 'Write buffer' })

      vim.keymap.set({ 'n', 'v' }, '<leader>gy', ':GBrowse!<CR>', { desc = 'Git status' })
    end,
    dependencies = { 'tpope/vim-rhubarb' },
  },

  { 'tpope/vim-abolish' },

  { 'zbirenbaum/copilot.lua', opts = {} },

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  { 'HiPhish/rainbow-delimiters.nvim', depends = { 'nvim-treesitter/nvim-treesitter' } },

  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup()

      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
    end,
  },
}
