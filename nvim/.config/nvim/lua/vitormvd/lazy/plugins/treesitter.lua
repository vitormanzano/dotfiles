return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = { "python", "javascript", "typescript", "c", "lua", "rust", "go", "vimdoc", "c_sharp", "bash", "html", "css"},
            auto_install = true,
            highlight = { enable = true },
        })
    end,
}
