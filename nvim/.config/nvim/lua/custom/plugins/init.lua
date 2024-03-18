-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
	{
		"Olical/conjure",
		dependencies = {
			{
				"PaterJason/cmp-conjure",
				config = function()
					local cmp = require("cmp")
					local config = cmp.get_config()
					table.insert(config.sources, {
						name = "buffer",
						option = {
							sources = {
								{ name = "conjure" },
							},
						},
					})
					cmp.setup(config)
				end,
			},
		},
		config = function(_, opts)
			require("conjure.main").main()
			require("conjure.mapping")["on-filetype"]()
		end,
		init = function()
			-- Put conjure keybinds further down the tree
			vim.g["conjure#mapping#prefix"] = "<localleader>c"
			vim.g["conjure#client#python#stdio#command"] = "python3 -iq -m asyncio"
		end,
	},
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
}
