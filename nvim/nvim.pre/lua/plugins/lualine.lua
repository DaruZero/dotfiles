return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {

      -- see copilot.lua...
      -- copilot = {
      --   lualine_component = "filename",
      -- },
      --
      -- see debug.lua...
      -- dap_status = {
      --  lualine_component = "filename",
      --  },
      --
      -- see noice.lua...
      -- noice = {
      --   lualine_component = "filename",
      -- },

      options = {
        theme = "auto",
      },
      -- sections = {
      --   lualine_a = { "mode" },
      --   lualine_b = { "branch", "diagnostics" },
      --   lualine_c = {
      --     {
      --       "filename",
      --       path = 1,
      --     },
      --   },
      --   lualine_x = { "encoding", "filetype" },
      --   lualine_y = { "progress" },
      --   lualine_z = { "location" },
      -- },
      extensions = { "neo-tree", "lazy", "mason", "man", "nvim-dap-ui", "trouble" },
    },
  },
}
