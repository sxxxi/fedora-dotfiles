vim.api.nvim_clear_autocmds({event={"FocusLost"}})

-- Save file when leaving the buffer, but only if it's not readonly
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = {"*"},
	callback = function()
		local hasBufName = not vim.fn.bufname("%") == ""
		local hasNoBufType = vim.bo.buftype == ""
		local bufWritable = not vim.bo.readonly

		if hasBufName and hasNoBufType and bufWritable then
            vim.cmd([[w]])
		end
    end
})

-- File specific configs
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "jsonc", "json", "lua", "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
	end
})

-- Open file explorer on startup
vim.api.nvim_create_autocmd("FocusLost", {
	callback = function()
		-- Open only if current buffer is an empty file
		if vim.fn.bufname("%") == "" then
			require"telescope".extensions.file_browser.file_browser()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)	-- Simulate pressing ESC
		end
	end
})
