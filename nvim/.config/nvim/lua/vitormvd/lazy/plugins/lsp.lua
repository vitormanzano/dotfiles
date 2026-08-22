 return {
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      opts = {
        ensure_installed = {
          "html",
          "cssls",
          "ts_ls",
          "clangd",
          "lua_ls",
          "rust_analyzer",
          "gopls",
          "angularls",
          "eslint",
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "saghen/blink.cmp",
        "williamboman/mason-lspconfig.nvim",
        {
          "folke/lazydev.nvim",
          ft = "lua",
          opts = {
            library = {
              { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
          },
        },
      },
      config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        vim.lsp.config("*", { capabilities = capabilities })

        local on_attach = function(_, bufnr)
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
        end,
      })

      local servers = { "html", "cssls", "clangd", "rust_analyzer", "gopls", "ts_ls" }
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Angular
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/angular-language-server"
      local ng_cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations", mason_path,
        "--ngProbeLocations", mason_path,
      }
      vim.lsp.config("angularls", {
        cmd = ng_cmd,
        filetypes = { "typescript", "html", "typescriptreact", "htmlangular" },
        root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
      })
      vim.lsp.enable("angularls")

      -- ESLint
      vim.lsp.config("eslint", {
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
      })
      vim.lsp.enable("eslint")
    end,
  },
}
