return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "hcl",
        "helm",
        "javascript",
        "json",
        "just",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "terraform",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },
}
