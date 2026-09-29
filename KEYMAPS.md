# Keymapy

<!-- Plik generowany przez :KeymapsDoc (lua/bartus/core/keymaps_doc.lua). Nie edytuj ręcznie. -->

Tryby: n = normal, i = insert, x = visual, s = select, o = operator (po d/c/y), t = terminal, c = linia komend.
`<leader>` = spacja. Skąd pochodzi mapa: `:verbose map <skrót>`.

## Z mojego configu

| Tryb | Skrót | Opis |
| --- | --- | --- |
| n, x, s | `<C-B>` | Przewiń ekran w górę |
| n, x, s | `<C-D>` | Przewiń pół ekranu w dół |
| n, x, s | `<C-E>` | Przesuń widok w dół |
| n, x, s | `<C-F>` | Przewiń ekran w dół |
| n | `<C-H>` | Przejdź do okna po lewej |
| n | `<C-L>` | Przejdź do okna po prawej |
| n, x, s | `<C-U>` | Przewiń pół ekranu w górę |
| n, x, s | `<C-Y>` | Przesuń widok w górę |
| n | `<F11>` | Debug: wejdź do funkcji (step into) |
| n | `<F12>` | Debug: wyjdź z funkcji (step out) |
| n | `<F5>` | Debug: uruchom / kontynuuj |
| n | `<F9>` | Debug: następna linia (step over) |
| n | `<leader>,` | Zwęż okno |
| n | `<leader>.` | Poszerz okno |
| n | `<leader>/` | Szukaj w bieżącym pliku |
| n | `<leader>b` | Debug: przełącz breakpoint |
| n | `<leader>ca` | Pokaż akcje kodu |
| n, x, s | `<leader>cf` | Sformatuj plik lub zaznaczenie |
| n | `<leader>cr` | Zmień nazwę symbolu w projekcie |
| n | `<leader>dr` | Wstaw referencję DLL do .csproj |
| n | `<leader>e` | Pokaż diagnostykę pod kursorem |
| n | `<leader>fb` | Znajdź otwarty bufor |
| n | `<leader>fd` | Znajdź TODO/FIXME w projekcie |
| n | `<leader>ff` | Znajdź plik |
| n | `<leader>fg` | Szukaj tekstu w projekcie (grep) |
| n | `<leader>fh` | Szukaj w :help |
| n | `<leader>fr` | Znajdź użycia symbolu (LSP) |
| n | `<leader>fs` | Znajdź symbol w pliku (LSP) |
| n | `<leader>ft` | Otwórz przeglądarkę plików (Oil) |
| n | `<leader>fw` | Znajdź symbol w projekcie (LSP) |
| n | `<leader>gd` | Przejdź do definicji (LSP) |
| n | `<leader>o` | Zapisz i wczytaj bieżący plik (:source) |
| n | `<leader>q` | Zamknij okno |
| n | `<leader>tm` | Otwórz terminal w bieżącym oknie |
| n | `<leader>tr` | Otwórz terminal po prawej (25%) |
| n | `<leader>tt` | Otwórz terminal pod spodem |
| n | `<leader>v` | Podziel okno pionowo |
| n | `<leader>w` | Zapisz plik |
| i | `<S-Tab>` | Poprzednia podpowiedź lub cofnij w snippecie |
| i | `<Tab>` | Akceptuj podpowiedź, skocz w snippecie lub za nawias |
| n, x, o | `[c` | Przejdź do poprzedniej klasy |
| n, x, o | `[f` | Przejdź do poprzedniej funkcji |
| n, x, o | `]c` | Przejdź do następnej klasy |
| n, x, o | `]f` | Przejdź do następnej funkcji |
| x, o | `aa` | Zaznacz parametr z przecinkiem |
| x, o | `ac` | Zaznacz całą klasę |
| x, o | `af` | Zaznacz całą funkcję |
| x, o | `aq` | Zaznacz "…" z cudzysłowami |
| n | `g[` | Przejdź do następnej diagnostyki |
| n | `g]` | Przejdź do poprzedniej diagnostyki |
| x, o | `ia` | Zaznacz parametr |
| x, o | `ic` | Zaznacz ciało klasy |
| x, o | `if` | Zaznacz ciało funkcji |
| x, o | `iq` | Zaznacz wnętrze "…" |
| n, x, s | `zb` | Ustaw linię na dole ekranu |
| n, x, s | `zt` | Ustaw linię na górze ekranu |
| n, x, s | `zz` | Ustaw linię na środku ekranu |

## Wbudowane i z pluginów

| Tryb | Skrót | Opis |
| --- | --- | --- |
| x | `#` | :help v_#-default |
| n | `&` | :help &-default |
| x | `*` | :help v_star-default |
| x | `<BS>` | Shrink selection to previous named node |
| i, s | `<C-S>` | vim.lsp.buf.signature_help() |
| x | `<C-Space>` | Increment selection to named node |
| n | `<C-Space>` | Start selecting nodes with nvim-treesitter |
| i | `<C-U>` | :help i_CTRL-U-default |
| i | `<C-W>` | :help i_CTRL-W-default |
| n | `<C-W><C-D>` | Show diagnostics under the cursor |
| n | `<C-W>d` | Show diagnostics under the cursor |
| s | `<S-Tab>` | vim.snippet.jump if active, otherwise <S-Tab> |
| s | `<Tab>` | vim.snippet.jump if active, otherwise <Tab> |
| x | `@` | :help v_@-default |
| n | `[<C-L>` | :lpfile |
| n | `[<C-Q>` | :cpfile |
| n | `[<C-T>` | :ptprevious |
| n | `[<Space>` | Add empty line above cursor |
| n | `[a` | :previous |
| n | `[A` | :rewind |
| n | `[b` | :bprevious |
| n | `[B` | :brewind |
| n | `[D` | Jump to the first diagnostic in the current buffer |
| n | `[d` | Jump to the previous diagnostic in the current buffer |
| n | `[l` | :lprevious |
| n | `[L` | :lrewind |
| n | `[q` | :cprevious |
| n | `[Q` | :crewind |
| n | `[t` | :tprevious |
| n | `[T` | :trewind |
| n | `]<C-L>` | :lnfile |
| n | `]<C-Q>` | :cnfile |
| n | `]<C-T>` | :ptnext |
| n | `]<Space>` | Add empty line below cursor |
| n | `]A` | :last |
| n | `]a` | :next |
| n | `]B` | :blast |
| n | `]b` | :bnext |
| n | `]D` | Jump to the last diagnostic in the current buffer |
| n | `]d` | Jump to the next diagnostic in the current buffer |
| n | `]L` | :llast |
| n | `]l` | :lnext |
| n | `]Q` | :clast |
| n | `]q` | :cnext |
| n | `]T` | :tlast |
| n | `]t` | :tnext |
| x | `an` | vim.lsp.buf.selection_range(vim.v.count1) |
| o | `gc` | Comment textobject |
| n, x | `gc` | Toggle comment |
| n | `gcc` | Toggle comment line |
| n | `gO` | vim.lsp.buf.document_symbol() |
| n, x | `gra` | vim.lsp.buf.code_action() |
| x | `grc` | Increment selection to surrounding scope |
| n | `gri` | vim.lsp.buf.implementation() |
| n | `grn` | vim.lsp.buf.rename() |
| n | `grr` | vim.lsp.buf.references() |
| n | `grt` | vim.lsp.buf.type_definition() |
| n, x | `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| x | `in` | vim.lsp.buf.selection_range(-vim.v.count1) |
| x | `Q` | :help v_Q-default |
| n | `Y` | :help Y-default |
