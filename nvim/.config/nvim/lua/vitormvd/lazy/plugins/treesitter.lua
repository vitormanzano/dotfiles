return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter.config").setup({
            ensure_installed = { "javascript", "typescript", "c", "lua", "rust", "go", "vimdoc" },
            auto_install = true,
            highlight = { enable = true },
        })
    end,
}
