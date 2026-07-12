local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
    },
}

for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch via npm start (Express)",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "start" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process (--inspect)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
        },
    }
end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: continue/start" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP: step out" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "DAP: toggle REPL" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "DAP: terminate" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: toggle UI" })
