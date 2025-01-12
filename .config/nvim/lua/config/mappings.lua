-- LSP magic
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>hh", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

-- Tabs
vim.keymap.set("n", "<Tab>", ":tabn<CR>", { noremap = true })
vim.keymap.set("n", "<S-Tab>", ":tabp<CR>", { noremap = true })

-- Diagnostic
vim.keymap.set("n", "<C-g><C-g>", function ()
	vim.diagnostic.setloclist()
end)
