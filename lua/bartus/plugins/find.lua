-- Szukanie plików, tekstu, symboli i TODO (telescope) oraz przeglądarka plików (oil).
-- Prefiksy: <leader>f (find), <leader>g (goto), <leader>/.
-- Zależy od: telescope.nvim, plenary.nvim, oil.nvim, todo-comments (dla <leader>fd), LSP (fr/fs/fw/gd).

require "telescope".setup({})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Znajdź plik' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Szukaj tekstu w projekcie (grep)' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Znajdź otwarty bufor' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Szukaj w :help' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Szukaj w bieżącym pliku' })
vim.keymap.set('n', '<leader>fd', ':TodoTelescope<CR>', { desc = 'Znajdź TODO/FIXME w projekcie' })

-- przez LSP
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Znajdź użycia symbolu (LSP)' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Znajdź symbol w pliku (LSP)' })
vim.keymap.set('n', '<leader>fw', builtin.lsp_workspace_symbols, { desc = 'Znajdź symbol w projekcie (LSP)' })
vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, { desc = 'Przejdź do definicji (LSP)' })

-- oil: katalog jako edytowalny bufor (zmień nazwę = edytuj linię, zapisz :w)
require "oil".setup()
vim.keymap.set('n', '<leader>ft', ':Oil<CR>', { desc = 'Otwórz przeglądarkę plików (Oil)' })
