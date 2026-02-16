return {
  -- Treesitter에 jinja 파서 추가
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "htmldjango" })
    end,
  },

  -- LSP 설정
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jinja_lsp = {},
      },
    },
  },

  -- 파일타입 인식
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.filetype.add({
        extension = {
          jinja = "jinja",
          jinja2 = "jinja",
          j2 = "jinja",
        },
        pattern = {
          [".*%.html%.jinja"] = "jinja",
          [".*%.html%.jinja2"] = "jinja",
          [".*%.html%.j2"] = "jinja",
        },
      })
    end,
  },
}
