local lsp_keymaps_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_keymaps_group,
    desc = "Create buffer-local keymaps for LSP",
    callback = function(args)
        local bufnr = args.buf
        local map = function(mode, lhs, rhs, desc)
            local opts = { buffer = bufnr, silent = true, desc = "LSP: " .. desc }
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        local telescope = require("telescope.builtin")

        -- Your keymap definitions go here
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
        map("n", "gr", vim.lsp.buf.references, "Go to References")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map("n", "<leader>fr", telescope.lsp_references, "Telescope References")
        map("n", "<leader>fi", telescope.lsp_implementations, "Telescope Implementations")
        map("n", "<leader>vs", telescope.lsp_document_symbols, "Telescope Symbols")

        -- Keymaps for Diagnostics
        map("n", "gl", vim.diagnostic.open_float, "Show Line Diagnostics")
        map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
    end,
})

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
                "html",      -- HTML
                "cssls",     -- CSS
                "ts_ls",     -- JavaScript & TypeScript
                "clangd",    -- C
                "yamlls",    -- YAML
                "bashls",    -- Bash
                "angularls", -- Angular
                "lua_ls",    -- Lua (Neovim)
                "jsonls",    -- JSON
            },
            automatic_installation = true,
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "prettier",  -- Formatter (HTML, CSS, JS, TS, YAML, JSON)
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local servers = {
                "html",
                "cssls",
                "ts_ls",
                "clangd",
                "yamlls",
                "bashls",
                "angularls",
                "lua_ls",
                "jsonls",
            }

            for _, server_name in ipairs(servers) do
                vim.lsp.config(server_name, {
                    capabilities = capabilities,
                })
                vim.lsp.enable(server_name)
            end

            -- Configuração específica para lua_ls reconhecer a variável global 'vim'
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })
        end,
    },
}
