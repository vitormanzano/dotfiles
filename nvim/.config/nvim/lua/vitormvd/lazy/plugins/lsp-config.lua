return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "tailwindcss",
        "pyright",
        "yamlls",
        "bashls",
        "clangd",
      },
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      local base_servers = { "ts_ls", "html", "lua_ls", "tailwindcss", "pyright", "yamlls", "bashls", "clangd" }

      for server, config in pairs(opts.servers or {}) do
        vim.lsp.config(server, config)
        table.insert(base_servers, server)
      end

      vim.lsp.enable(base_servers)

      vim.diagnostic.config({
        signs = true,
        underline = true,
        update_in_insert = true,
        virtual_text = { spacing = 4, prefix = "■" },
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = { buffer = args.buf }
          vim.keymap.set("n", "K",          vim.lsp.buf.hover,         map)
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition,    map)
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references,    map)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,   map)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,        map)
          vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format,        map)
          vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,  map)
          vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,  map)
          vim.keymap.set("n", "<leader>d",  vim.diagnostic.open_float, map)
        end,
      })
    end,
  },
}
