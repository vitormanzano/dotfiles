return {
  "GustavEikaas/easy-dotnet.nvim",
  ft = { "cs", "fsharp", "csproj", "fsproj", "sln", "slnx", "razor" },
  cmd = "Dotnet",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("easy-dotnet").setup({
      lsp = {
        enabled = true,
        roslynator_enabled = true,
      },
      debugger = {
        engine = "netcoredbg",
        auto_register_dap = true,
      },
      test_runner = {
        viewmode = "float",
      },
    })

    local dap = require("dap")
    local map = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, map)
    vim.keymap.set("n", "<leader>dc", dap.continue, map)
    vim.keymap.set("n", "<leader>di", dap.step_into, map)
    vim.keymap.set("n", "<leader>do", dap.step_over, map)
    vim.keymap.set("n", "<leader>dO", dap.step_out, map)
    vim.keymap.set("n", "<leader>dt", dap.terminate, map)

    local dotnet = require("easy-dotnet")
    vim.keymap.set("n", "<leader>tt", dotnet.testrunner, map)
    vim.keymap.set("n", "<leader>tr", dotnet.test, map)
    vim.keymap.set("n", "<leader>tR", dotnet.test_solution, map)
  end,
}
