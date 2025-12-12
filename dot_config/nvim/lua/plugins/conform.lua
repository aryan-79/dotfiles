return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "biome", "prettier", stop_after_first = true },
      typescript = { "biome", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettier", stop_after_first = true },
      css = { "biome", "prettier", stop_after_first = true },
      html = { "biome", "prettier", stop_after_first = true },
      json = { "biome", "prettier", stop_after_first = true },
      markdown = { "biome", "prettier", stop_after_first = true },
    },
    formatters = {
      prettier = {
        command = vim.fn.stdpath("data") .. "/mason/bin/prettierd",
        prefer_local = "node_modules/.bin",
        condition = function(ctx)
          return vim.fs.find({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yaml",
            ".prettierrc.yml",
            ".prettierrc.js",
            ".prettierrc.cjs",
          }, { path = ctx.filename, upward = true })[1]
        end,
      },
      biome = {
        -- command = vim.fn.stdpath("data") .. "/mason/bin/biome",
        prefer_local = "node_modules/.bin",
        -- condition = function(ctx)
        --   return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
        -- end,
      },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
