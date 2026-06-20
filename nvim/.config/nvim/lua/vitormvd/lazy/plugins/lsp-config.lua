  return {
    {
      "williamboman/mason.nvim",
      lazy = false,
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = false,
      opts = {
        ensure_installed = {
          -- "lua_ls",
          -- "ts_ls",
          -- "html",
          -- "tailwindcss",
          -- "pyright",   -- Python
          -- "yamlls",    -- YAML
          -- "bashls",
          -- "clangd",
        },
        auto_install = true,
      },
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.lsp.config("*", { capabilities = capabilities })
        vim.lsp.enable({ "ts_ls", "html", "lua_ls", "tailwindcss", "pyright", "yamlls", "clangd" })

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local opts = { buffer = args.buf }
            vim.keymap.set("n", "K",           vim.lsp.buf.hover,       opts)
            vim.keymap.set("n", "<leader>gd",  vim.lsp.buf.definition,  opts)
            vim.keymap.set("n", "<leader>gr",  vim.lsp.buf.references,  opts)
            vim.keymap.set("n", "<leader>ca",  vim.lsp.buf.code_action, opts)
          end,
        })
      end,
    },
  }
