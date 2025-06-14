local watch_timers = {}

local function detect_filetype(output)
  -- Try to detect JSON (starts with { or [)
  if output:match('^%s*[%[{]') then
    return 'json'
  end
  -- Try to detect YAML (starts with --- or has many ":" and no { or [)
  if output:match('^%s*---') or (output:match(':') and not output:match('[%[{]')) then
    return 'yaml'
  end
  -- Add more detection as needed
  return 'text'
end

vim.api.nvim_create_user_command('WatchCommand', function(opts)
  local command = opts.args
  local interval = tonumber(opts.fargs[2]) or 2

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_name(buf, 'Watch: ' .. command)

  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, buf)

  local last_output = nil
  local function update_buffer(output)
    if output ~= last_output then
      last_output = output
      local lines = vim.split(output, '\n', true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

      -- Detect and set filetype
      local filetype = detect_filetype(output)
      vim.api.nvim_buf_set_option(buf, 'filetype', filetype)
    end
  end

  local function run_command()
    vim.fn.jobstart(command, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          local output = table.concat(data, '\n')
          update_buffer(output)
        end
      end,
    })
  end

  local timer = vim.loop.new_timer()
  watch_timers[buf] = timer
  timer:start(0, interval * 1000, vim.schedule_wrap(run_command))

  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = buf,
    once = true,
    callback = function()
      if watch_timers[buf] then
        watch_timers[buf]:stop()
        watch_timers[buf]:close()
        watch_timers[buf] = nil
      end
    end,
  })
end, {
  nargs = '+',
  complete = 'shellcmd',
  desc = 'Watch a shell command and update buffer on output change',
})
