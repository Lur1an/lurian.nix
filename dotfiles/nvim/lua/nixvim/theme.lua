local M = {}

local function remove_mason_command()
    pcall(vim.api.nvim_del_user_command, "MasonInstallAll")
end

function M.pre()
    vim.g.base46_cache = vim.fn.stdpath("cache") .. "/nvim/base46/"
    require("base46").load_all_highlights()
end

function M.post()
    -- nvchad schedules its au.lua (registers :MasonInstallAll); our deletion
    -- queues after it, removing the unusable command in the same tick.
    require("nvchad")
    vim.schedule(remove_mason_command)
end

return M
