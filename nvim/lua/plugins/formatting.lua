return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- sh 파일타입에 대한 기존 설정을 함수로 변경하여 조건부 적용         ▄
      opts.formatters_by_ft["sh"] = function(bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        -- 파일명이 .env를 포함하면 포매터 사용 안 함
        if filename:match("%.env") then
          return {}
        end
        return { "shfmt" }
      end
    end,
  },
}
