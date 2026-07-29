return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  dependencies = {
    "scottmckendry/cyberdream.nvim",
    "nyoom-engineering/oxocarbon.nvim",
    "folke/tokyonight.nvim",
    "AlexvZyl/nordic.nvim",
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

    require("cyberdream").setup({
      transparent = true,
      italic_comments = true,
    })

    require("tokyonight").setup({
      style = "night",
      transparent = true,
    })

    require("nordic").setup({
        transparent = { bg = true, float = true },
    })

    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
    })

vim.cmd("colorscheme rose-pine")
  end
}
