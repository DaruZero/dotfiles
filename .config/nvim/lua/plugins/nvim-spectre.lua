return {
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = {
      find_engine = {
        -- rg is map with finder_cmd
        ["rg"] = {
          -- default args
          args = {
            "--pcre2",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
        },
      },
    },
  },
}
