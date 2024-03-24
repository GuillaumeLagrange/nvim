return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    require('mini.ai').setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    require('mini.surround').setup()

    require('mini.bufremove').setup()
    vim.keymap.set('n', '<leader>bd', function()
      local bd = require('mini.bufremove').delete
      if vim.bo.modified then
        local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
        if choice == 1 then -- Yes
          vim.cmd.write()
          bd(0)
        elseif choice == 2 then -- No
          bd(0, true)
        end
      else
        bd(0)
      end
    end, { desc = 'Delete Buffer' })

    vim.keymap.set('n', '<leader>bD', function()
      require('mini.bufremove').delete(0, true)
    end, { desc = 'Delete Buffer (force)' })

    require('mini.sessions').setup()
    require('mini.starter').setup()

    -- Simple and easy statusline.
    local statusline = require('mini.statusline')
    statusline.setup({ use_icons = vim.g.have_nerd_font })
    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function()
      -- Relative file name with modified and ro flags
      return '%f%m%r'
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.inactive = function()
      -- Relative file name with modified and ro flags
      return '%#MiniStatuslineInactive#%f%='
    end
  end,
}
