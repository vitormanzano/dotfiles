return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "angularls", "eslint" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/angular-language-server"
      local ng_cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations", mason_path,
        "--ngProbeLocations",  mason_path,
      }

      opts.servers = opts.servers or {}

      opts.servers.angularls = {
        cmd = ng_cmd,
        filetypes = { "typescript", "html", "typescriptreact", "htmlangular" },
        on_new_config = function(new_config)
          new_config.cmd = ng_cmd
        end,
        root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
      }

      opts.servers.eslint = {
        settings = {
          workingDirectory = { mode = "auto" },
          format = true,
          run = "onType",
        },
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      }
    end,
  },
}
