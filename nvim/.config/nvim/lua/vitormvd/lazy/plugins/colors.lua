return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    dependencies = {
        "navarasu/onedark.nvim",
        "scottmckendry/cyberdream.nvim",
        "folke/tokyonight.nvim",
        "AlexvZyl/nordic.nvim",
        "vague-theme/vague.nvim",
        "evergardentheme/nvim",
        "ellisonleao/gruvbox.nvim",
        { "catppuccin/nvim", name = "catppuccin" },
    },
    config = function()
        vim.opt.background = "dark"

        -- === setup de cada tema (transparência ligada) ===
        require("rose-pine").setup({
            variant = "moon",
            extend_background_behind_borders = true,
            styles = { bold = true, italic = true, transparency = true },
        })

        require("evergarden").setup({
            theme = {
                variant = 'fall',
                accent = 'green',
            },
            editor = {

            }
        })

        require("vague").setup({
            transparent = true,
            italic = true,
        })

        require("cyberdream").setup({
            transparent = true,
            italic_comments = true,
        })

        require("gruvbox").setup({
            terminal_colors = true,
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = "",  -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = true,
        })

        require("tokyonight").setup({
            style = "night",
            light_style = "day",
            transparent = false,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                sidebars = "dark",
                floats = "dark",
            },
        })

        require("nordic").setup({
            transparent = { bg = true, float = true },
        })

        require("catppuccin").setup({
            flavour = "auto",
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true,
            term_colors = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                telescope = { enabled = true },
                mini = { enabled = true },
            },
        })

        require("onedark").setup({
            style = 'darker'
        })

        vim.cmd("colorscheme gruvbox")
    end
}
