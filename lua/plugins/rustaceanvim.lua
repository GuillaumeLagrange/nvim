vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  ---@type RustaceanLspClientOpts
  server = {
    load_vscode_settings = true,
    auto_attach = function(bufnr)
      -- Lsp auto start causes mini freezes because of how review buffers are handled
      local review = require('octo.reviews').get_current_review()
      if review then
        -- cant find an active review
        return false
      end

      return true
    end,
    on_attach = function(client, _)
      client.server_capabilities.workspace.didChangeWatchedFiles = {
        dynamicRegistration = false,
        relativePatternSupport = false,
      }

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        desc = 'Resize splits when resizing the window',
        pattern = { '*.rs' },
        callback = function()
          vim.cmd('RustAnalyzer reloadSettings')
        end,
      })
    end,
    default_settings = {
      ['rust-analyzer'] = {
        cachePriming = false,
        rustfmt = {
          extraArgs = {
            '--config',
            'comment_width=120,condense_wildcard_suffixes=false,format_code_in_doc_comments=true,format_macro_bodies=true,hex_literal_case=Upper,imports_granularity=One,normalize_doc_attributes=true,wrap_comments=true',
          },
        },
      },
    },
  },
  -- DAP configuration
  dap = {},
}

return {
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
    dev = true,
  },
}
