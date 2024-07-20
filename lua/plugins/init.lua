return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  'tpope/vim-abolish',

  { 'numToStr/Comment.nvim', opts = {} },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghw", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
      end,
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register({
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      })
    end,
  },

  {
    'j-hui/fidget.nvim',
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
      progress = {
        lsp = {
          progress_ringbuf_size = 4096,
        },
      },
    },
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  {
    'sainnhe/gruvbox-material',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    lazy = false,
    init = function()
      vim.cmd.colorscheme('gruvbox-material')
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'tpope/vim-fugitive',
    lazy = false,
    keys = {
      { '<leader>gs', '<cmd>Git<CR>', mode = 'n', desc = 'Git status' },
      { '<leader>gb', '<cmd>Git blame<cr>', mode = 'n', desc = 'Git blame' },
      { '<leader>gr', '<cmd>Gread<cr>', mode = 'n', desc = 'Read buffer' },
      { '<leader>gw', '<cmd>Gwrite<cr>', mode = 'n', desc = 'Write buffer' },
      { '<leader>gd', '<cmd>Gdiff<cr>', mode = 'n', desc = 'Git diff' },

      { '<leader>gy', ':GBrowse!<CR>', mode = { 'n', 'v' }, desc = 'Git yank key' },
    },
    dependencies = { 'tpope/vim-rhubarb' },
  },

  {
    'zbirenbaum/copilot.lua',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = '<M-y>',
          accept_word = '<M-w>',
          accept_line = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<M-d>',
        },
      },
    },
  },

  {
    'ojroques/vim-oscyank',
    config = function()
      -- Should be accompanied by a setting clipboard in tmux.conf, also see
      -- https://github.com/ojroques/vim-oscyank#the-plugin-does-not-work-with-tmux
      vim.g.oscyank_term = 'default'
      vim.g.oscyank_max_length = 0 -- unlimited
      -- Below autocmd is for copying to OSC52 for any yank operation,
      -- see https://github.com/ojroques/vim-oscyank#copying-from-a-register
      vim.api.nvim_create_autocmd('TextYankPost', {
        pattern = '*',
        callback = function()
          if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
            vim.cmd('OSCYankRegister "')
          end
        end,
      })
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        hijack_cursor = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
      })

      -- Handle session restore
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = 'NvimTree*',
        callback = function()
          local view = require('nvim-tree.view')
          local is_visible = view.is_visible()

          local api = require('nvim-tree.api')
          if not is_visible then
            api.tree.open()
          end
        end,
      })

      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle NvimTree' })
      vim.keymap.set('n', '<leader>E', '<cmd>NvimTreeFindFileToggle!<CR>', { desc = 'Toggle NvimTree' })
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
    },
    keys = {
      {
        '<leader>H',
        function()
          require('harpoon'):list():append()
        end,
        desc = 'Harpoon File',
      },
      {
        '<leader>h',
        function()
          local harpoon = require('harpoon')
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon Quick Menu',
      },
      {
        '<leader>1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Harpoon to File 1',
      },
      {
        '<leader>2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Harpoon to File 2',
      },
      {
        '<leader>3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Harpoon to File 3',
      },
      {
        '<leader>4',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Harpoon to File 4',
      },
      {
        '<leader>5',
        function()
          require('harpoon'):list():select(5)
        end,
        desc = 'Harpoon to File 5',
      },
    },
  },

  {
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
    },
    keys = {
      { '<leader>gpo', '<cmd>Octo pr<CR>', mode = 'n', desc = 'Open PR for current branch' },
      { '<leader>gpy', '<cmd>Octo pr url<CR>', mode = 'n', desc = 'Yank PR url' },
      {
        '<leader>gpr',
        function()
          vim.g.auto_ra_attach = not vim.g.auto_ra_attach
          vim.print(vim.g.auto_ra_attach)
        end,
        mode = 'n',
        desc = 'Disable ra auto attach',
      },
      { '<leader>gca', '<cmd>Octo comment add<CR>', mode = 'n', desc = 'Add comment' },
    },
  },

  {
    'akinsho/git-conflict.nvim',
    version = '*',
    lazy = false,
    opts = { highlights = { current = 'DiffChange' } },
    keys = {
      { '<leader>gcq', '<cmd>GitConflictListQf<CR>', mode = 'n', desc = 'Git conflicts to quickfix' },
      { '<leader>gco', '<cmd>GitConflictChooseOurs<CR>', mode = 'n', desc = 'Git conflicts choose ours' },
      { '<leader>gct', '<cmd>GitConflictChooseTheirs<CR>', mode = 'n', desc = 'Git conflicts choose theirs' },
      { '<leader>gcb', '<cmd>GitConflictChooseBoth<CR>', mode = 'n', desc = 'Git conflicts choose both' },
      { '<leader>gcn', '<cmd>GitConflictChooseNone<CR>', mode = 'n', desc = 'Git conflicts choose none' },
    },
  },

  { 'rickhowe/diffchar.vim' },

  {
    'nvim-pack/nvim-spectre',

    keys = {
      { '<leader>sr', '<cmd>lua require("spectre").toggle()<CR>', mode = 'n', desc = 'Toggle Spectre' },
    },
  },
}
