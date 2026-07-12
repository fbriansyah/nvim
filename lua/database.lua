-- vim-dadbod-ui config (must be set before the plugin's commands are used)
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

-- local dev connections, shown in the DB UI sidebar (<leader>Du)
-- edit host/port/db name to match your setup, or add more with :DBUIAddConnection
-- vim.g.dbs = {
--     local_redis = "redis://localhost:6379/0",
-- }

-- for real credentials, don't hardcode them here — reference env vars instead, e.g.:
-- staging_postgres = "postgres://$DB_USER:$DB_PASSWORD@staging-host:5432/dbname",

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql" },
    callback = function()
        vim.bo.omnifunc = "vim_dadbod_completion#omnifunc"
    end,
})

vim.keymap.set("n", "<leader>Du", "<cmd>DBUIToggle<CR>", { desc = "Toggle Database UI" })
vim.keymap.set("n", "<leader>Da", "<cmd>DBUIAddConnection<CR>", { desc = "Add DB connection" })
vim.keymap.set("n", "<leader>Df", "<cmd>DBUIFindBuffer<CR>", { desc = "Find DB UI buffer" })
