local M = {}

local function get_session_name()
  local name = string.gsub(vim.fn.getcwd(), '/', '_')
  local branch = vim.trim(vim.fn.system('git branch --show-current'))
  if vim.v.shell_error == 0 and branch ~= '' then
    return name .. '_' .. branch
  else
    return name
  end
end

if vim.fn.argc(-1) == 0 then
  vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained' }, {
    nested = true,
    callback = function()
      local session_name = get_session_name()

      -- Save session for current branch
      if vim.v.this_session ~= '' then
        MiniSessions.write()
      end

      if MiniSessions.detected[session_name] and string.find(vim.v.this_session, session_name) == nil then
        MiniSessions.read(session_name)
      else
        -- If we are opening a new branch, create a session for the new branch with current state
        MiniSessions.write(get_session_name())
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      if vim.v.this_session == '' then
        return
      end

      MiniSessions.write(get_session_name())
    end,
  })
end

M.delete_all = function()
  -- Delete all sessions in MiniSessions.detected
  for _, session in pairs(MiniSessions.detected) do
    if string.find(vim.v.this_session, session.name) == nil then
      MiniSessions.delete(session.name)
    end
  end
end

return M
