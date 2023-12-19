vim.g.mapleader = " "

function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<A-Left>', ':bp<CR>')
map('n', '<A-Right>', ':bn<CR>')
map('n', '<A-Up>', ':wincmd w<CR>')

-- Resizing
vim.keymap.set('n', '<C-<>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C->>', ':vertical resize +2<CR>')

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<Leader>ff', telescope.git_files, {})
vim.keymap.set('n', '<Leader>pf', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})
vim.keymap.set('n', '<leader>fs', function() require("telescope").extensions.aerial.aerial() end)

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-CR>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Clipboard
vim.api.nvim_set_keymap("v", "<Leader>y", '"+y', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>y", '"+y', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>Y", '"+yg_', { noremap = true })

vim.api.nvim_set_keymap("v", "<Leader>p", '"+p', { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>P", '"+P', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>p", '"+p', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>P", '"+P', { noremap = true })

-- Disable Arrow Keys
for _, mode in pairs({ 'n', 'i', 'v', 'x' }) do
    for _, key in pairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
        vim.keymap.set(mode, key, '<nop>')
    end
end