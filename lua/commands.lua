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


--- run a TUI tool (lazygit/lazydocker/yazi/...) in a floating terminal (no plugin needed) ---
-- cmd    : executable name (used for the PATH check + default title)
-- opts   : { args = {...}, on_exit = function() end }
--          args overrides the full command; on_exit runs after the window closes
local function float_term(cmd, opts)
    opts = opts or {}
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
        title = " " .. cmd .. " ",
        title_pos = "center",
    })

    vim.fn.jobstart(opts.args or { cmd }, {
        term = true,
        on_exit = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            if opts.on_exit then
                opts.on_exit()
            end
            -- reload files changed on disk and refresh mini.diff signs
            vim.cmd("checktime")
        end,
    })
    vim.cmd("startinsert")
end

-- yazi as a file picker: --chooser-file makes yazi write the picked path(s) to
-- a temp file on <Enter> and quit, so we can open them in the host Neovim.
local function open_yazi()
    local chooser = vim.fn.tempname()
    local path = vim.api.nvim_buf_get_name(0)
    local start = (path ~= "" and vim.fn.filereadable(path) == 1) and path or vim.fn.getcwd()

    float_term("yazi", {
        args = { "yazi", start, "--chooser-file", chooser },
        on_exit = function()
            if vim.fn.filereadable(chooser) == 0 then
                return
            end
            local chosen = vim.fn.readfile(chooser)
            vim.fn.delete(chooser)
            for i, file in ipairs(chosen) do
                if file ~= "" then
                    -- open the first pick in the current window, add the rest as buffers
                    vim.cmd((i == 1 and "edit " or "badd ") .. vim.fn.fnameescape(file))
                end
            end
        end,
    })
end

vim.keymap.set("n", "<leader>gl", function() float_term("lazygit") end, { desc = "Open lazygit (floating)" })
vim.keymap.set("n", "<leader>ld", function() float_term("lazydocker") end, { desc = "Open lazydocker (floating)" })
vim.keymap.set("n", "<leader>yz", open_yazi, { desc = "Open Yazi (floating file picker)" })
