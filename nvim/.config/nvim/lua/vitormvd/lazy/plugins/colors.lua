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
        "webhooked/kanso.nvim",
        "kamil-stachowski/vinyl.nvim",
        'projekt0n/github-nvim-theme',
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
            transparent = true,
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

        require('kanso').setup({
            bold = true,      -- enable bold fonts
            italics = true,   -- enable italics
            compile = false,  -- enable compiling the colorscheme
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = true },
            statementStyle = {},
            typeStyle = {},
            transparent = false,   -- do not set background color
            dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
            terminalColors = true, -- define vim.g.terminal_color_{0,17}
            colors = {             -- add/modify theme and palette colors
                palette = {},
                theme = { zen = {}, pearl = {}, ink = {}, all = {} },
            },
            overrides = function(colors) -- add/modify highlights
                return {}
            end,
            background = {          -- map the value of 'background' option to a theme
                dark = "ink",       -- try "zen", "mist" or "pearl" !
                light = "pearl"     -- try "zen", "mist" or "ink" !
            },
            foreground = "default", -- "default" or "saturated" (can also be a table like background)
            minimal = false,        -- reduced color palette for a more minimal look
        })

        require("vinyl").setup({
            variant = "darker", -- the default is "lighter"
            overrides = {
                ["@string"] = { fg = "#00ff00" },
            },
        })

        require("github-theme").setup {
            options = {
                transparent = true,
                hide_nc_statusline = false,
                hide_end_of_buffer = false,
                inverse = {
                    match_paren = true,
                    -- visual = true,
                    search = true,
                },
            }
        }

        vim.cmd("colorscheme tokyonight")
    end
}
