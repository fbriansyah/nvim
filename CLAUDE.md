# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration targeting **Neovim 0.12+**. It leans heavily on
Neovim's built-in tooling rather than third-party wrappers: `vim.pack` for plugin
management (not lazy.nvim/packer), `vim.lsp.config`/`vim.lsp.enable` for LSP (not
`lspconfig`'s setup wrappers), and the `mini.nvim` suite for the editing UX.
There is no build/lint/test step — changes take effect by reloading Neovim.

## Applying changes

- Reload the whole config from inside Neovim: `:restart` (also mapped to `<leader>re`).
- Plugin management commands are custom-defined in `lua/commands.lua`:
  `:PackAdd user/repo`, `:PackDel plugin`, `:PackUpdate [plugin...]` (no args = update all).
- `nvim-pack-lock.json` pins plugin commits; it is managed by `vim.pack`, don't hand-edit.
- Undo history persists to `$XDG_DATA/undodir` (the top-level `undodir/` here is stale).

## Load order (init.lua)

`init.lua` requires modules in a deliberate order — **`pack` must load before any
module that calls `require()` on a plugin**, since `vim.pack.add` in `lua/pack.lua`
is what makes those plugins available. Order: `options` → `keymaps` → `commands` →
`pack` → `lsp` → `treesitter` → `format` → `dap_config` → `database` →
`kulala_config`, then the colorscheme. When adding a new feature module, add its
plugin to `lua/pack.lua` and its `require` to `init.lua` in the right slot.

## Module map (lua/)

Each file owns one concern and registers its own keymaps at the bottom:

- **pack.lua** — declares all plugins via `vim.pack.add`, then configures the entire
  `mini.nvim` suite inline (files, notify, cmdline, surround, pick/extra, completion,
  snippets, diff) plus fugitive and package-info. This is the largest file and the
  place most UX keymaps live (`<leader>ff`, `<leader>ps`, `-` file explorer, `<leader>g*` git).
- **lsp.lua** — Mason + mason-tool-installer for tool installation; servers configured
  with `vim.lsp.config(name, ...)` then activated with `vim.lsp.enable({...})`.
  Note the Vue setup: `ts_ls` gets the `@vue/typescript-plugin` wired in to type-check
  `<script>` blocks, while `vue_ls` handles templates/CSS. Completion capabilities come
  from `mini.completion`, not nvim-cmp.
- **format.lua** — conform.nvim with prettier. Format-on-save is intentionally
  **disabled for JS/TS(X)** (the `disable_filetypes` table) to avoid fighting eslint;
  those are formatted manually via `<leader>f`.
- **treesitter.lua** — uses the `main` branch of nvim-treesitter (new API:
  `treesitter.install()` + a FileType autocmd that starts highlighting per-buffer).
- **dap_config.lua** — nvim-dap for Node/JS/TS debugging via `js-debug-adapter`
  (pwa-node adapter). `<leader>d*` keymaps.
- **database.lua** — vim-dadbod-ui. `<leader>D*` keymaps.
- **kulala_config.lua** — REST client for `.http` files. `<leader>r*` keymaps.
- **commands.lua** — the custom `:Pack*` user commands.
- **options.lua** / **keymaps.lua** — global settings and editor keymaps. Leader is Space.

## Conventions

- Every keymap uses a `{ desc = "..." }` so it's discoverable via `<leader>pk`
  (keymap picker). Keep this up when adding maps.
- Namespaced leader prefixes by domain: `d`=debug, `D`=database, `r`=REST,
  `n`=npm/package-info, `g`=git, `p`/`f`/`v`=pickers.
- The stack is oriented toward **Node.js / Express / Vue / TypeScript** development
  (LSP servers, formatters, debug adapters, and REST tooling are all chosen for it),
  with Go and Rust LSP also enabled.

## Secrets

`.env` is committed but `.gitignore`d going forward; a prior commit (`029d22d`)
removed hardcoded database creds. `lua/database.lua` documents the pattern: reference
env vars in connection strings (`postgres://$DB_USER:$DB_PASSWORD@...`), never hardcode.
