-- As dotnet global tools (dotnet-easydotnet, roslyn-language-server, dotnet-ef) ficam em
-- ~/.dotnet/tools, que só entra no PATH via .zshrc. Quando o nvim é aberto sem um zsh
-- interativo (ex.: Hyprland -> ghostty -e yazi -> nvim) o Roslyn não sobe. Garantimos aqui.
local dotnet_tools = vim.fs.joinpath(vim.env.HOME, ".dotnet", "tools")
if not vim.env.PATH:find(dotnet_tools, 1, true) then
    vim.env.PATH = dotnet_tools .. ":" .. vim.env.PATH
end

-- Trabalha sempre a partir da raiz da solution (.sln/.slnx), como o Rider/Visual Studio.
-- O easy-dotnet só procura a solution subindo até o diretório atual. Se o nvim abre dentro de
-- src/Projeto (ex.: pelo yazi), ele não acha a .sln, o Roslyn carrega só aquele .csproj e o gd
-- para outros projetos cai em código descompilado. Build/run/testes também partem do cwd.
local function cd_to_solution_root()
    local cwd = vim.uv.cwd()
    if not cwd then return end
    cwd = vim.fs.normalize(cwd)

    local start = cwd
    local arg = vim.fn.argv(0)
    if arg ~= "" then
        local abs = vim.fs.normalize(vim.fn.fnamemodify(arg, ":p"))
        start = vim.fn.isdirectory(abs) == 1 and abs or vim.fs.dirname(abs)
    end

    local sln = vim.fs.find(function(name) return name:match("%.slnx?$") ~= nil end, {
        path = start,
        upward = true,
        stop = vim.env.HOME,
        limit = 1,
    })[1]
    if not sln then return end

    -- Só sobe se o cwd estiver DENTRO da solution; na raiz ou fora dela o easy-dotnet já acha a .sln
    local root = vim.fs.dirname(sln)
    if vim.startswith(cwd, root .. "/") then
        vim.cmd.cd(vim.fn.fnameescape(root))
    end
end
cd_to_solution_root()

-- O easy-dotnet guarda a solution escolhida por cwd (stdpath("data")/easy-dotnet/solutions/<sha256(cwd)>)
-- e nunca confere se ela pertence ao diretório. Se o cwd muda (:cd, picker de projetos) com o picker de
-- solution pendente, a escolha é gravada no hash do diretório errado e todo nvim aberto ali carrega a
-- solution de outro projeto. Descarta o cache quando a solution não está dentro do cwd (nem o cwd dentro dela).
local function drop_foreign_cached_solution()
    local current = require("easy-dotnet.current_solution")
    local sln = current.try_get_selected_solution()
    if not sln then return end

    local cwd = vim.fs.normalize(vim.fn.getcwd())
    local root = vim.fs.dirname(sln)
    if not (vim.startswith(sln, cwd .. "/") or vim.startswith(cwd, root .. "/")) then
        current.clear_selected_solution()
    end
end

return {
    {
        "GustavEikaas/easy-dotnet.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "folke/snacks.nvim" },
        config = function()
            drop_foreign_cached_solution() -- antes do setup: preload_roslyn já inicializa com a solution do cache
            local dotnet = require("easy-dotnet")
            dotnet.setup({
                managed_terminal = {
                    auto_hide = true,       -- auto hides terminal if exit code is 0
                    auto_hide_delay = 1000, -- delay before auto hiding, 0 = instant
                },
                external_terminal = nil,
                -- Roslyn LSP: o mesmo servidor do VS Code C# Dev Kit / Visual Studio
                lsp = {
                    enabled = true,
                    set_fold_expr = false,
                    preload_roslyn = true,               -- Start loading roslyn before any buffer is opened
                    roslynator_enabled = true,           -- Roslynator analyzers/refactorings (estilo ReSharper)
                    easy_dotnet_analyzer_enabled = true,
                    easy_dotnet_extension_enabled = true, -- Necessário para os dois abaixo
                    enhanced_rename = true,              -- Renomear classe também renomeia o arquivo (como no Rider)
                    create_type_from_usage = true,       -- Code action "criar tipo a partir do uso" em arquivo próprio
                    auto_refresh_codelens = true,
                    analyzer_assemblies = {},            -- Analyzers extras, ex.: SonarAnalyzer.CSharp
                    config = {
                        settings = {
                            ["csharp|completion"] = {
                                dotnet_show_completion_items_from_unimported_namespaces = true,
                                dotnet_show_name_completion_suggestions = true,
                            },
                            ["csharp|symbol_search"] = {
                                dotnet_search_reference_assemblies = true,
                            },
                            ["csharp|inlay_hints"] = {
                                dotnet_enable_inlay_hints_for_parameters = true,
                                dotnet_enable_inlay_hints_for_literal_parameters = true,
                                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                            },
                            ["csharp|code_lens"] = {
                                dotnet_enable_references_code_lens = true, -- "N references" acima dos membros
                            },
                            navigation = {
                                dotnet_navigate_to_decompiled_sources = true, -- gd em tipos do BCL/NuGet
                                dotnet_navigate_to_source_link_and_embedded_sources = true,
                            },
                        },
                    },
                },
                debugger = {
                    -- nil = usa o netcoredbg que vem com o easy-dotnet-server
                    bin_path = nil,
                    console = "integratedTerminal",
                    apply_value_converters = true,
                    auto_register_dap = true,
                    mappings = {
                        open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
                    },
                },
                test_runner = {
                    auto_start_testrunner = true,
                    hide_legend = false,
                    viewmode = "float",
                    vsplit_width = nil,
                    vsplit_pos = nil,
                    icons = {
                        passed = "",
                        skipped = "",
                        failed = "",
                        success = "",
                        reload = "",
                        test = "",
                        sln = "󰘐",
                        project = "󰘐",
                        dir = "",
                        package = "",
                        class = "",
                        build_failed = "󰒡",
                    },
                    mappings = {
                        run_test_from_buffer = { lhs = "<leader>tr", desc = "run test from buffer" },
                        run_all_tests_from_buffer = { lhs = "<leader>tf", desc = "run all tests in file" },
                        run = { lhs = "<leader>tr", desc = "run test" },
                        debug_test_from_buffer = { lhs = "<leader>td", desc = "debug test from buffer" },
                        debug_test = { lhs = "<leader>td", desc = "debug test" },
                        get_build_errors = { lhs = "<leader>te", desc = "get build errors" },
                        peek_stack_trace_from_buffer = { lhs = "<leader>tp", desc = "peek stack trace from buffer" },
                        run_all = { lhs = "<leader>tR", desc = "run all tests" },
                        go_to_file = { lhs = "g", desc = "go to file" },
                        peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
                        expand = { lhs = "o", desc = "expand" },
                        expand_node = { lhs = "E", desc = "expand node" },
                        collapse_all = { lhs = "W", desc = "collapse all" },
                        close = { lhs = "q", desc = "close testrunner" },
                        refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
                        cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
                    },
                },
                new = {
                    project = {
                        prefix = "sln", -- "sln" | "none"
                    },
                },
                csproj_mappings = true,
                fsproj_mappings = true,
                auto_bootstrap_namespace = {
                    type = "file_scoped", -- block_scoped | file_scoped
                    enabled = true,
                    use_clipboard_json = {
                        behavior = "prompt", -- 'auto' | 'prompt' | 'never'
                        register = "+",
                    },
                },
                server = {
                    ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
                    log_level = nil,
                },
                picker = "snacks", -- "telescope" | "fzf" | "snacks" | "basic"
                diagnostics = {
                    default_severity = "error",
                    setqflist = false,
                },
            })

            vim.api.nvim_create_user_command("Secrets", function() dotnet.secrets() end, {})

            -- Inlay hints ligados por padrão em C# (como Rider/VS). Toggle: <leader>ih
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("DotnetInlayHints", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if vim.bo[args.buf].filetype == "cs" and client and client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                    end
                end,
            })

            -- Ações de projeto/solução estilo IDE, prefixo <leader>n (.NET)
            local map = function(lhs, cmd, desc)
                vim.keymap.set("n", lhs, "<cmd>" .. cmd .. "<cr>", { desc = "Dotnet: " .. desc })
            end
            map("<leader>nb", "Dotnet build default quickfix", "Build (erros no quickfix)")
            map("<leader>nB", "Dotnet build solution quickfix", "Build solution")
            map("<leader>nr", "Dotnet run default", "Run")
            map("<leader>nR", "Dotnet run profile default", "Run com launch profile")
            map("<leader>nw", "Dotnet watch default", "Watch (hot reload)")
            map("<leader>nd", "Dotnet debug default", "Debug")
            map("<leader>nt", "Dotnet testrunner", "Test Explorer")
            map("<leader>ne", "Dotnet diagnostic", "Erros/warnings da solution")
            map("<leader>np", "Dotnet add package", "Adicionar NuGet")
            map("<leader>no", "Dotnet outdated", "Pacotes desatualizados")
            map("<leader>nn", "Dotnet new", "Novo projeto/item")
            map("<leader>ns", "Dotnet solution select", "Selecionar solution")
            map("<leader>nc", "Dotnet clean", "Clean")
            map("<leader>nT", "Dotnet terminal toggle", "Toggle terminal")
            vim.keymap.set("n", "<leader>nL", function() dotnet.lsp_restart() end, { desc = "Dotnet: Restart LSP" })
        end,
    },
    {
        -- UI de debug (variáveis, watches, call stack, breakpoints, console), estilo Rider/VS
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()

            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
            vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

            -- Teclas iguais ao Visual Studio. Shift+F5/F11 chegam como <F17>/<F23> em alguns terminais.
            local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = "Debug: " .. desc }) end
            map("<F5>", dap.continue, "Start/Continue")
            map("<S-F5>", dap.terminate, "Stop")
            map("<F17>", dap.terminate, "Stop")
            map("<F9>", dap.toggle_breakpoint, "Toggle breakpoint")
            map("<F10>", dap.step_over, "Step over")
            map("<F11>", dap.step_into, "Step into")
            map("<S-F11>", dap.step_out, "Step out")
            map("<F23>", dap.step_out, "Step out")
            map("<C-F10>", dap.run_to_cursor, "Run to cursor")
            map("<F7>", dapui.toggle, "Toggle debug UI")
            map("<leader>b", dap.toggle_breakpoint, "Toggle breakpoint")
            map("<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Condição: "))
            end, "Conditional breakpoint")
            vim.keymap.set({ "n", "v" }, "<leader>?", function() dapui.eval(nil, { enter = true }) end,
                { desc = "Debug: Avaliar expressão" })
        end,
    },
}
