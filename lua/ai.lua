--- Supermaven: AI inline code suggestion (ghost text) ---
-- Renders suggestions as virtual text, separate from the mini.completion
-- LSP popup, so the two don't fight. First run will prompt to sign in via
-- `:SupermavenUseFree` (free tier) or `:SupermavenUsePro`.
require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
    },
    -- Don't offer AI suggestions where they're noise or risky.
    ignore_filetypes = { "dbui", "dbout", "minifiles", "http" },
    color = {
        suggestion_color = "#808080",
        cterm = 244,
    },
    disable_inline_completion = false, -- keep ghost text on
    disable_keymaps = false,
})

local sm = require("supermaven-nvim.api")

vim.keymap.set("n", "<leader>at", sm.toggle, { desc = "AI: toggle Supermaven suggestions" })
vim.keymap.set("n", "<leader>as", sm.restart, { desc = "AI: restart Supermaven" })
