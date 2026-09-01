return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "gopls",
                    -- "omnisharp",
                    "svelte",
                    "tailwindcss",
                    -- "phpactor",
                    "intelephense",
                    "gdscript",
                    "gdtoolkit",
                    "astro",
                    "html",
                    "clangd",
                    -- "roslyn",
                    "rust_analyzer",
                    "templ",
                    "kotlin_language_server",
                    "zls",
                    "ols",
                    "cssls",
                    "pyright"
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- require("mason-lspconfig").setup_handlers({
            -- 	-- The first argument is a function that gets called for each server
            -- 	-- that is installed with Mason.
            -- 	function(server_name)
            -- 		require("lspconfig")[server_name].setup({
            -- 			-- You can add capabilities for autocompletion engines here
            -- 			-- capabilities = require("cmp_nvim_lsp").default_capabilities()
            -- 		})
            -- 	end,
            --
            -- 	-- You can also override settings for specific servers here
            -- 	["lua_ls"] = function()
            -- 		require("lspconfig").lua_ls.setup({
            -- 			settings = {
            -- 				Lua = {
            -- 					diagnostics = {
            -- 						globals = { "vim" },
            -- 					},
            -- 				},
            -- 			},
            -- 		})
            -- 	end,
            -- })
            vim.lsp.config("ts_ls", {})
            vim.lsp.enable({ "ts_ls" })
            vim.lsp.config("gopls", {})
            vim.lsp.enable({ "gopls" })
            vim.lsp.config("gdscript", {})
            vim.lsp.enable({ "gdscript" })
            vim.lsp.config("gdtoolkit", {})
            vim.lsp.enable({ "gdtoolkit" })
            -- local lspconfig = require("lspconfig")
            -- lspconfig.lua_ls.setup({})
            -- lspconfig.ts_ls.setup({})
            -- lspconfig.gopls.setup({})
            -- lspconfig.gdscript.setup({})
            -- lspconfig.svelte.setup({})
            -- lspconfig.tailwindcss.setup({})
            -- lspconfig.intelephense.setup({})
            -- lspconfig.astro.setup({})
            -- lspconfig.html.setup({})
            -- lspconfig.clangd.setup({})
            -- lspconfig.roslyn.setup({})
            -- lspconfig.rust_analyzer.setup({})
            -- lspconfig.templ.setup({})
            -- lspconfig.kotlin_language_server.setup({
            -- 	filetypes = { "kotlin", "kt", "kts" },
            -- })
            -- lspconfig.zls.setup({})

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    -- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    -- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    -- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                    -- map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                    -- map(
                    -- 	"<leader>ws",
                    -- 	require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    -- 	"[W]orkspace [S]ymbols"
                    -- )
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    map("gh", vim.lsp.buf.hover, "Hover Documentation")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.name == "gopls" then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = event.buf,
                            callback = function()
                                local params = vim.lsp.util.make_range_params(0, "utf-8")
                                params.context = { only = { "source.organizeImports" } }

                                local result = vim.lsp.buf_request_sync(event.buf, "textDocument/codeAction", params,
                                    1000)
                                for _, res in pairs(result or {}) do
                                    for _, action in pairs(res.result or {}) do
                                        if action.edit then
                                            vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                                        end

                                        if action.command then
                                            vim.lsp.buf.execute_command(action.command)
                                        end

                                        return
                                    end
                                end
                            end,
                        })
                    end
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })
        end,
    },
}
