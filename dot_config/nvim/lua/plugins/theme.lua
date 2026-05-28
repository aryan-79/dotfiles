return {
  -- {
  --   "folke/tokyonight.nvim",
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      transparent = true,

      theme = "lotus",
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none", -- line number column
            },
          },
        },
      },

      overrides = function(colors)
        local theme = colors.theme

        local makeDiagnosticColor = function(color)
          local c = require("kanagawa.lib.color")
          return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
        end
        return {
          Normal = { bg = "none" },
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = "none", fg = theme.ui.fg_dim },
          MasonNormal = { bg = "none", fg = theme.ui.fg_dim },

          TelescopeNormal = { bg = "none" },
          TelescopeBorder = { bg = "none" },
          TelescopePromptNormal = { bg = "none" },
          TelescopePromptBorder = { bg = "none" },
          TelescopeResultsNormal = { bg = "none" },
          TelescopeResultsBorder = { bg = "none" },
          TelescopePreviewNormal = { bg = "none" },
          TelescopePreviewBorder = { bg = "none" },

          -- most plugins link to NormalFloat, but force just in case
          SnacksNormal = { bg = "none" },

          Pmenu = { bg = "none" },
          PmenuSel = {},
          PmenuSbar = { bg = "none" },
          PmenuThumb = { bg = "none" },

          StatusLine = { bg = "none" },
          StatusLineNC = { bg = "none" },
          VertSplit = { bg = "none" },

          DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
          DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
          DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
          DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
        }
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
