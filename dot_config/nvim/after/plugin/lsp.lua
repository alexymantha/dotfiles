local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- none-ls
local none_ls = require("null-ls")

none_ls.setup({
    sources = {
        none_ls.builtins.formatting.prettier,
        none_ls.builtins.formatting.goimports
    }
})

-- Mason
-- Needs to be setup before lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        -- Languages
        "gopls",
        "pyright",
        "tsserver",
        "lua_ls",
        "rust_analyzer",
        -- Tools
        "terraformls",
        "dockerls",
        "helm_ls",
        -- Markup
        "yamlls",
        "jsonls",
    },

    handlers = {
        function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({
                capabilities = capabilities
            })
        end,

        ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            }
        end,
    }
})

-- Prolog stuff
-- TODO: Remove after AI class
require('lspconfig').prolog_ls.setup({
    capabilities = capabilities
})
vim.filetype.add({
    extension = {
        pl = 'prolog',
    },
})

vim.keymap.set('n', '[e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<Leader>fd', ':Telescope diagnostics<CR>')

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'L', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>bf', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        print(vim.inspect(client))
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("UserLspFormat", { clear = true }),
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format()
                end
            })
        end
    end,
})
