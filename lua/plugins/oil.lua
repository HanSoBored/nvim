return {
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			keymaps = {
				["<F5>"] = "actions.refresh",
			},
		},
		keys = {
			{
				"-",
				"<CMD>Oil<CR>",
				desc = "Open parent directory",
			},
		},
	},
}
