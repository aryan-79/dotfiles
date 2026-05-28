return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      tools = {
        -- claude = {
        --   cmd = { "ollama", "launch", "claude", "--model", "minimax-m2.5:cloud" },
        -- },
        opencode = {
          cmd = { "ollama", "launch", "opencode", "--model", "minimax-m2.5:cloud" },
        },
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if require("sidekick").nes_jump_or_apply() then
          return -- jumped or applied
        end

        -- if you are using Neovim's native inline completions
        if vim.lsp.inline_completion.get() then
          return
        end

        -- any other things (like snippets) you want to do on <tab> go here.

        -- fall back to normal tab
        return "<tab>"
      end,
      mode = { "i", "n" },
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },

    {
      "<c-s>",
      function()
        require("sidekick.cli").focus()
      end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
  },
}
