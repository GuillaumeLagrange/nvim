return {
  'ofseed/copilot-status.nvim',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'ofseed/copilot-status.nvim' },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            'branch',
            fmt = function(branch_name)
              local max_len = 20
              if #branch_name <= max_len then
                return branch_name
              end

              return branch_name:sub(1, max_len - 3) .. '..'
            end,
          },
          'diff',
          'diagnostics',
        },
        lualine_c = { { 'filename', path = 1, shorting_target = 70 } },
        lualine_x = {
          {
            'copilot',
            show_running = true,
            symbols = {
              status = {
                enabled = ' ',
                disabled = ' ',
              },
              spinners = {
                '⠋',
                '⠙',
                '⠹',
                '⠸',
                '⠼',
                '⠴',
                '⠦',
                '⠧',
                '⠇',
                '⠏',
              },
            },
          },
          'encoding',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
}
