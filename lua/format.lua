require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        -- goimports fixes imports first, gofumpt applies stricter gofmt
        go = { "goimports", "gofumpt" },
    },
    format_on_save = function(bufnr)
        local disable_filetypes = {
            javascript = true,
            javascriptreact = true,
            typescript = true,
            typescriptreact = true,
        }
        if disable_filetypes[vim.bo[bufnr].filetype] then
            return
        end
        return {
            timeout_ms = 1000,
            lsp_format = "fallback",
        }
    end,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer (conform)" })
