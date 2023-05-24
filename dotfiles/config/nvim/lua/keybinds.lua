function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<Leader>n', ':CHADopen<CR>')
map('n', '<C-w><Left>', ':bp<CR>')
map('n', '<C-w><Right>', ':bn<CR>')