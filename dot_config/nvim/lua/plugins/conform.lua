return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier", "biome", stop_after_first = true },
      typescript = { "prettier", "biome", stop_after_first = true },
      javascriptreact = { "prettier", "biome", stop_after_first = true },
      typescriptreact = { "prettier", "biome", stop_after_first = true },
      css = { "prettier", "biome", stop_after_first = true },
      html = { "prettier", "biome", stop_after_first = true },
      json = { "prettier", "biome", stop_after_first = true },
      markdown = { "prettier", "biome", stop_after_first = true },
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
            ".prettierrc.mjs",
            ".prettierrc.toml",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }, { path = ctx.filename, upward = true })[1]
        end,
      },
      biome = {
        prefer_local = "node_modules/.bin",
      },
    },
  },
}
