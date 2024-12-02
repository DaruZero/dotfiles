return {
  -- add onenord theme
  {
    "rmehri01/onenord.nvim",
    enabled = false,
  },
  -- add nordic theme
  {
    "AlexvZyl/nordic.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").load()
    end,
  },
  -- add kanagawa theme
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    config = function()
      require("kanagawa").setup({
        overrides = function(colors)
          local palette = colors.palette
          return {
            CursorLine = { bg = palette.waveBlue1 },
            Visual = { bg = "#363646" },
          }
        end,
      })
    end,
  },
  -- nightfox.nvim
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
  },

  -- Configure LazyVim to load the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
}
