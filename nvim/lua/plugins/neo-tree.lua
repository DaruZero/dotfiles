return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          always_show = { ".gitlab-ci.yml", ".gitlab-ci", ".github", ".gitlab" },
        },
      },
    },
  },
}
