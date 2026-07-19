vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2)" })

-- Pack Delete and Update cmds are built-in on Nightly 0.13
vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
    -- checks if any argument is passed
    if opts.args:match("%S") then
        -- update specific plugins
        local plugins = vim.split(opts.args, "%s+", { trimempty = true })
        -- update only specified plugins
        vim.pack.update(plugins)
    else
        -- update all
        vim.pack.update()
    end
end, { nargs = "*", desc = "Update all plugins or specific ones" })


--- run a TUI tool (lazygit/lazydocker/...) in a floating terminal (no plugin needed) ---
local function float_term(cmd, title)
    if vim.fn.executable(cmd) == 0 then
        vim.notify(cmd .. " not found on PATH", vim.log.levels.ERROR)
        return
    end

    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " " .. (title or cmd) .. " ",
        title_pos = "center",
    })

    vim.fn.jobstart({ cmd }, {
        term = true,
        on_exit = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            -- reload files changed on disk and refresh mini.diff signs
            vim.cmd("checktime")
        end,
    })
    vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>gl", function() float_term("lazygit") end, { desc = "Open lazygit (floating)" })
vim.keymap.set("n", "<leader>ld", function() float_term("lazydocker") end, { desc = "Open lazydocker (floating)" })
