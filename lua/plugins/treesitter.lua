return {
	{
	 "nvim-treesitter/nvim-treesitter",
	 build = ":TSUpdate",
	 opts = {
		 ensure_installed = {
			             "c",
				     "cpp",
				     "lua",
				     "vim",
				     "query",
				     "vimdoc",
				     "markdown",
				     "markdown_inline",
		},
		highlight = {
			     enable = true,
		},
		indent = {
			  enable = true,
		},
	},
	config = function(_, opts)
	require("nvim-treesitter.config").setup(opts)
        end,
       },
}
