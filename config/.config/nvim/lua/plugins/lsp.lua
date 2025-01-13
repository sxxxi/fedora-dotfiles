local masonEnsureInstalled = {
	"bashls",
	"dockerls",
	"html",
	"intelephense",
	"lua_ls",
	"stimulus_ls",
	"ts_ls",
	"rust_analyzer",
}

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp"
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup {
				sources = {
					{name = 'nvim_lsp'},
				},
				snippet = {
					expand = function(args)
						-- You need Neovim v0.10 to use vim.snippet
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({}),
			}
		end,
	},
	{ 
		"neovim/nvim-lspconfig",
		config = function()
			require('java').setup()
			require('lspconfig').jdtls.setup({})

			-- Reserve a space in the gutter
			vim.opt.signcolumn = 'yes'

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			local lspconfig_defaults = require('lspconfig').util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lspconfig_defaults.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
			)

			-- This is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = function(event)
					local opts = {buffer = event.buf}
					

					vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
					vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
					vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
					vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
					vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
					vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
					vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
					vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
					vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
					vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				end,
			})
		end
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		}
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = masonEnsureInstalled,
			automatic_installation = true,
			handlers = {
				-- The first function applied to every language server without a custom handler
				function(server_name)
					local lspconfig = require("lspconfig")
					lspconfig[server_name].setup {}
				end,

				-- Shell
				bashls = function()
					require("lspconfig").bashls.setup {
						filetypes = {
							"sh", "bash", "zsh"
						}
					}
				end,

				-- Dockerfile
				dockerls = function()
					require("lspconfig").dockerls.setup {
						settings = {
							docker = {
								languageserver = {
									formatter = {
										ignoreMultilineInstructions = true,
									},
								},
							}
						}
					}
				end,

				-- Lua
				lua_ls = function()
					require'lspconfig'.lua_ls.setup {
						on_init = function(client)
							if client.workspace_folders then
								local path = client.workspace_folders[1].name
								if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
									return
								end
							end

							client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
								runtime = {
									-- Tell the language server which version of Lua you're using
									-- (most likely LuaJIT in the case of Neovim)
									version = 'LuaJIT'
								},
								-- Make the server aware of Neovim runtime files
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME
									}
								}
							})
						end,
						settings = {
							Lua = {}
						}
					}
				end,

			},
		},
	},
}
