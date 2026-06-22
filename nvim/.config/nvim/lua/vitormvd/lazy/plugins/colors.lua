return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  dependencies = {
    "scottmckendry/cyberdream.nvim",
    "nyoom-engineering/oxocarbon.nvim",
    "folke/tokyonight.nvim",
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
    -- oxocarbon não tem flag de transparência; o autocmd abaixo resolve

    -- força transparência em QUALQUER tema (cobre o oxocarbon também)
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        for _, g in ipairs({ "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn" }) do
          vim.api.nvim_set_hl(0, g, { bg = "none" })
        end
      end,
    })
    vim.cmd("colorscheme rose-pine")
  end
}
