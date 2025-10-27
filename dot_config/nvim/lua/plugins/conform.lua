return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier", "biome" },
      typescript = { "prettier", "biome" },
      javascriptreact = { "prettier", "biome" },
      typescriptreact = { "prettier", "biome" },
      css = { "prettier", "biome" },
      html = { "prettier", "biome" },
      json = { "prettier", "biome" },
      markdown = { "prettier", "biome" },
    },
    formatters = {
      prettier = {
        -- command = vim.fn.stdpath("data") .. "/mason/bin/prettierd",
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
        condition = function(ctx)
          return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
