require("mason").setup()

require("mason-tool-installer").setup({
    ensure_installed = {
        "typescript-language-server",
        "vue-language-server",
        "eslint-lsp",
        "prettier",
        "js-debug-adapter",
    },
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

local servers = {
    -- ts_ls needs the @vue/typescript-plugin wired in so it can type-check
    -- <script> blocks inside .vue files (vue_ls handles templates/CSS on its own)
    ts_ls = {
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        init_options = {
            plugins = {
                {
                    name = '@vue/typescript-plugin',
                    location = vim.fn.stdpath('data') ..
                    '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                    languages = { 'vue' },
                },
            },
        },
    },

    vue_ls = {}, -- Vue language server (handles template + CSS)

    eslint = {
        settings = {
            workingDirectories = { mode = "auto" },
        },
    },
}

vim.lsp.config("ts_ls", servers.ts_ls)
vim.lsp.config("vue_ls", servers.vue_ls)
vim.lsp.config("eslint", servers.eslint)

-- run ESLint's auto-fix on save for JS/TS/Vue files
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" },
--   callback = function(args)
--     local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "eslint" })
--     if #clients > 0 then
--       vim.cmd("EslintFixAll")
--     end
--   end,
-- })

vim.lsp.enable({
    "lua_ls",
    "marksman",
    "gopls",
    "rust_analyzer",
    "ts_ls",
    "vue_ls",
    "eslint",
})
