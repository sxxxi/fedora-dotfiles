return {
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local telescope =require"telescope"
			telescope.setup {
				extensions = {
					file_browser = {
						grouped = true,
						sorting_strategy = "ascending",
						hidden = true,
						respect_gitignore = false,
					}
				}
			}
			telescope.load_extension "file_browser"
		end,
		keys = {
			{
				"<leader>ft",
				function()
					local builtin = require("telescope.builtin")
					builtin.treesitter()
				end,
				desc="Telescope file finder",
			},
			{
				"<leader>ff",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						hidden = true,
						no_igrnore = false
					})
				end,
				desc="Telescope file finder",
			},
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc="Telescope help tags"},
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc="Telescope live grep"},
			{
				"<leader>fb",
				function()
					require('telescope').extensions.file_browser.file_browser({ 
						cwd = vim.fn.expand('%:p:h'),
						hidden = true
					})
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)	-- Simulate pressing ESC
				end,
				desc = "Telescope file browser in file's directory"
			},
		},
	},
}
