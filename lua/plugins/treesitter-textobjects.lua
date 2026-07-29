return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},

		opts = {
			select = {
				enable = true,
				lookahead = true,
				selection_modes = {
					["@function.outer"] = "V",
					["@class.outer"] = "V",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
			},
		},

		config = function(_, opts)
			require("nvim-treesitter-textobjects").setup(opts)

			local ts_sel = require("nvim-treesitter-textobjects.select")
			local ts_move = require("nvim-treesitter-textobjects.move")
			local mode_xo = { "x", "o" }

			-- select: vaf / vif (function), vac / vic (class)
			vim.keymap.set(mode_xo, "af", function()
				ts_sel.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set(mode_xo, "if", function()
				ts_sel.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set(mode_xo, "ac", function()
				ts_sel.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set(mode_xo, "ic", function()
				ts_sel.select_textobject("@class.inner", "textobjects")
			end)

			-- move: ]f / [f (next/prev function)
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				ts_move.goto_next_start("@function.outer")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				ts_move.goto_previous_start("@function.outer")
			end)
		end,
	},
}
