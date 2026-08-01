local function oil_cwd()
  local ok, oil = pcall(require, "oil")
  if ok then
    local dir = oil.get_current_dir()
    if dir then
      return dir
    end
  end
  return vim.fn.getcwd()
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ cwd = oil_cwd() })
        end,
        desc = "Find Files (Oil-aware)",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({ cwd = oil_cwd() })
        end,
        desc = "Find Grep (Oil-aware)",
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Fuzzy find in buffer",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help",
      },
    },
  },
}
