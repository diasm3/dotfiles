return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = false,
          terminal_colors = true,
          styles = {
            comments = "italic",
            keywords = "bold",
            functions = "NONE",
            variables = "NONE",
          },
          sidebars = { "qf", "help" },
          darken = {
            floats = true,
            sidebars = {
              enable = true,
            },
          },
        },
      })
      vim.cmd("colorscheme github_dark")
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark",
    },
  },
}
