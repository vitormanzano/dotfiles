-- nvim-treesitter (branch main) não aceita mais ensure_installed/highlight no setup():
-- os parsers são instalados com install() (precisa do tree-sitter CLI, instalado via Mason)
-- e o highlight é ligado com vim.treesitter.start() em cada buffer.
return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    dependencies = { "williamboman/mason.nvim" }, -- coloca o tree-sitter CLI do Mason no PATH
    config = function()
        local ts = require("nvim-treesitter")
        ts.setup()
        ts.install({
            "python", "javascript", "typescript", "c", "lua", "rust", "go", "vimdoc", "bash", "html", "css",
            -- .NET: C#, Razor e as injeções que o easy-dotnet usa (csproj = xml, appsettings = json, SQL em strings)
            "c_sharp", "razor", "xml", "json", "sql",
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}
