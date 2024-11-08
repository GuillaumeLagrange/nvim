local session = require('session')

return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    require('mini.ai').setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    require('mini.surround').setup()

    require('mini.files').setup({
      mappings = {
        close = 'q',
        go_in = '<C-L>',
        go_in_plus = 'L',
        go_out = '<C-H>',
        go_out_plus = 'H',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },
    })

    require('mini.pairs').setup({
      mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
      },
    })

    require('mini.indentscope').setup({
      -- Draw options
      draw = {
        -- Delay (in ms) between event and start of drawing scope indicator
        delay = 100,

        -- Animation rule for scope's first drawing. A function which, given
        -- next and total step numbers, returns wait time (in ms). See
        -- |MiniIndentscope.gen_animation| for builtin options. To disable
        -- animation, use `require('mini.indentscope').gen_animation.none()`.
        --<function: implements constant 20ms between steps>,
        animation = require('mini.indentscope').gen_animation.none(),

        -- Symbol priority. Increase to display on top of more symbols.
        priority = 2,
      },

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Textobjects
        object_scope = 'ii',
        object_scope_with_border = 'ai',

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = '[i',
        goto_bottom = ']i',
      },

      -- Options which control scope computation
      options = {
        -- Type of scope's border: which line(s) with smaller indent to
        -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
        border = 'both',

        -- Whether to use cursor column when computing reference indent.
        -- Useful to see incremental scopes with horizontal cursor movements.
        indent_at_cursor = true,

        -- Whether to first check input line to be a border of adjacent scope.
        -- Use it if you want to place cursor on function header to get scope of
        -- its body.
        try_as_border = false,
      },

      -- Which character to use for drawing scope indicator
      symbol = '|',
    })

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

    require('mini.sessions').setup({
      file = '',
      verbose = { read = true, write = false, delete = true },
      hooks = { pre = { write = session.close_ephemeral_buffers } },
    })

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

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_git = function(args)
      if vim.bo.buftype ~= '' then
        return ''
      end
      -- Truncated git branch

      local head = vim.b.gitsigns_head or '-'
      local truncated_head = string.sub(head, 1, 20)
      local signs = statusline.is_truncated(args.trunc_width) and '' or (vim.b.gitsigns_status or '')
      local icon = args.icon or (vim.g.have_nerd_font and '') or 'Git'

      if signs == '' then
        if truncated_head == '-' or truncated_head == '' then
          return ''
        end
        return string.format('%s %s', icon, truncated_head)
      end
      return string.format('%s %s %s', icon, truncated_head, signs)
    end
  end,
}
