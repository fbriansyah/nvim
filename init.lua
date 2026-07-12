require("vim._core.ui2").enable({})

require("options")
require("keymaps")
require("commands")
require("pack")
require("lsp")
require("treesitter")
require("format")
require("dap_config")
require("database")

require("catppuccin").setup({
    flavour = "mocha",
})

vim.cmd.colorscheme("catppuccin")
