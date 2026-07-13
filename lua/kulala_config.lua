--- kulala (REST client for .http files, test Express endpoints) ---
require("kulala").setup({
    -- kulala-core is the external binary kulala shells out to for actually
    -- sending requests (like curl, but with better JS/scripting support)
    kulala_core = {
        path = nil,     -- nil = auto-download the right binary for your OS/arch
        timeout = 60000,
        data_dir = nil, -- nil = default XDG data dir for cookies/OAuth/prompts
    },

    -- restore request history + open UI panes after `:mksession` / sourcing a session
    session = {
        restore = true,
    },

    -- kulala manages its own tree-sitter parser/queries for .http syntax
    treesitter = {
        enable = true,
        cli_path = "tree-sitter",
    },


    ui = {
        display_mode = "split",
        split_direction = "right",
        winbar = true,
        show_icons = "on_request",
        show_request_summary = true,
        default_view = "body",
    },
})

vim.keymap.set("n", "<leader>rr", "<cmd>lua require('kulala').run()<CR>", { desc = "Run REST request under cursor" })
vim.keymap.set("n", "<leader>rp", "<cmd>lua require('kulala').jump_prev()<CR>", { desc = "Prev REST request" })
vim.keymap.set("n", "<leader>rn", "<cmd>lua require('kulala').jump_next()<CR>", { desc = "Next REST request" })
