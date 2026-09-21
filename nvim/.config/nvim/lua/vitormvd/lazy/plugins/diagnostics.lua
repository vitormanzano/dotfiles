vim.diagnostic.config({
    virtual_text = true,
    underline = false,
    signs = false,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "always",
    },
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#eb6f92" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#f6c177" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#9ccfd8" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#c4a7e7" })
    end,
})

return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>" },
        },
        opts = {},
    },
}
