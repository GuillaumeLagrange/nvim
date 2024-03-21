vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    load_vscode_settings = true,
    default_settings = {
      ['rust-analyzer'] = {},
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
