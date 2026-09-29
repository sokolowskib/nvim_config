-- Ogólne keymapy niezależne od pluginów: pliki, okna, terminal, diagnostyka.
-- Prefiksy: <leader>t (terminal), pojedyncze <leader>w/q/o/e/v/,/.
-- Zależy tylko od wbudowanego API Neovima.

-- pliki
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = 'Zapisz plik' })
vim.keymap.set('n', '<leader>q', ':quit<CR>', { desc = 'Zamknij okno' })
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>', { desc = 'Zapisz i wczytaj bieżący plik (:source)' })

-- diagnostyka (błędy/ostrzeżenia LSP)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Pokaż diagnostykę pod kursorem' })
vim.keymap.set('n', 'g[', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Przejdź do następnej diagnostyki' })
vim.keymap.set('n', 'g]', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Przejdź do poprzedniej diagnostyki' })

-- textobjecty dla cudzysłowu: ciq, daq, viq…
vim.keymap.set({ "x", "o" }, "aq", 'a"', { desc = 'Zaznacz "…" z cudzysłowami' })
vim.keymap.set({ "x", "o" }, "iq", 'i"', { desc = 'Zaznacz wnętrze "…"' })

-- okna
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'Podziel okno pionowo' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Przejdź do okna po lewej' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Przejdź do okna po prawej' })
vim.keymap.set('n', '<leader>,', ':vertical resize -2<CR>', { desc = 'Zwęż okno' })
vim.keymap.set('n', '<leader>.', ':vertical resize +2<CR>', { desc = 'Poszerz okno' })

-- terminal (wyjście z trybu terminala: <C-\><C-n>)
vim.keymap.set('n', '<leader>tt', ':below terminal<CR>', { desc = 'Otwórz terminal pod spodem' })
vim.keymap.set('n', '<leader>tm', ':term<CR>', { desc = 'Otwórz terminal w bieżącym oknie' })
vim.keymap.set('n', '<leader>tr', function()
	vim.cmd('botright vsplit | terminal')
	vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.25))
	vim.cmd('startinsert')
end, { desc = 'Otwórz terminal po prawej (25%)' })
