# Config Neovima

Neovim **nightly (0.12-dev)** instalowany przez `bob`, macOS (Apple Silicon).
Pluginy przez wbudowany `vim.pack` (bez lazy.nvim). `<leader>` = **spacja**.

Nie pamiętasz skrótu? Wciśnij `<Space>` i poczekaj chwilę (which-key pokaże grupy)
albo zajrzyj do [KEYMAPS.md](KEYMAPS.md). Ta ściąga jest generowana komendą
`:KeymapsDoc`; uruchom ją po każdej zmianie skrótów.

---

## Spis treści

1. [Szybki start i struktura configu](#1-szybki-start-i-struktura-configu)
2. [Szukanie i poruszanie się po kodzie](#2-szukanie-i-poruszanie-się-po-kodzie)
3. [Formatowanie i LSP](#3-formatowanie-i-lsp)
4. [Nowy projekt w Ruście](#4-nowy-projekt-w-ruście)
5. [Kompilacja i skakanie po błędach](#5-kompilacja-i-skakanie-po-błędach)
6. [Debugowanie C / C++ / Rust / C# (DAP)](#6-debugowanie-c--c--rust--c-dap)
7. [Edycja: szablony, snippety, surround, textobjecty](#7-edycja-szablony-snippety-surround-textobjecty)
8. [Jak zmienić config (plugin, serwer LSP, skrót)](#8-jak-zmienić-config)
9. [Instalacja od zera na nowym Macu](#9-instalacja-od-zera-na-nowym-macu)
10. [Troubleshooting](#10-troubleshooting)

---

## 1. Szybki start i struktura configu

```
~/.config/nvim/
├── init.lua                   tylko require'y, kolejność ładowania
├── README.md                  ten plik
├── KEYMAPS.md                 generowany przez :KeymapsDoc (nie edytuj ręcznie)
├── nvim-pack-lock.json        zainstalowane wersje pluginów
├── lsp/
│   └── roslyn.lua             własne ustawienia serwera C# (łączone z domyślnymi)
├── lua/bartus/
│   ├── pack.lua               LISTA PLUGINÓW (vim.pack.add)
│   ├── core/
│   │   ├── options.lua        opcje, <leader>, diagnostyka
│   │   ├── keymaps.lua        skróty ogólne: pliki, okna, terminal, diagnostyka
│   │   ├── autocmds.lua       powrót do ostatniej pozycji, podświetlenie yank
│   │   └── keymaps_doc.lua    komenda :KeymapsDoc
│   └── plugins/
│       ├── find.lua           telescope + oil           <leader>f, <leader>g, <leader>/
│       ├── lsp.lua            mason, lista serwerów     <leader>ca, <leader>cr
│       ├── completion.lua     blink.cmp, Smart Tab      (insert)
│       ├── formatting.lua     conform                   <leader>cf
│       ├── treesitter.lua     podświetlanie, textobjecty af/if, ]f [f
│       ├── debug.lua          nvim-dap, dap-ui          F5 F9 F11 F12, <leader>b, <leader>dr
│       ├── editing.lua        todo-comments, szablony, auto-nawiasy
│       └── ui.lua             which-key, kolory, lualine, animacje
├── skeleton/                  szablony nowych plików (c, cpp, hpp, Makefile)
└── snippets/                  snippety blink (cs.json)
```

**Gdzie szukać, gdy chcesz coś zmienić:** każdy plik zaczyna się od 2–3 linii
komentarza (co robi, jakie ma skróty, od czego zależy). Szukanie po całym configu:
otwórz nvim w `~/.config/nvim` i użyj `<leader>fg`.

**Najczęstsze skróty:**

| Chcę… | Skrót |
| --- | --- |
| znaleźć plik / tekst w projekcie | `<leader>ff` / `<leader>fg` |
| przeglądać katalog (tworzyć, zmieniać nazwy plików) | `<leader>ft` |
| przejść do definicji / zobaczyć użycia | `<leader>gd` / `<leader>fr` |
| dokumentację symbolu | `K` |
| zmienić nazwę symbolu / akcje kodu | `<leader>cr` / `<leader>ca` |
| zobaczyć błąd pod kursorem / następny błąd | `<leader>e` / `g[` (lub `]d`) |
| sformatować | `<leader>cf` (i automatycznie przy `:w`) |
| terminal | `<leader>tt` (pod spodem), `<leader>tr` (po prawej) |
| zapisać / zamknąć | `<leader>w` / `<leader>q` |

---

## 2. Szukanie i poruszanie się po kodzie

Wszystko pod `<leader>f` (telescope). W okienku telescope: `<C-n>`/`<C-p>` wybór,
`<CR>` otwórz, `<C-v>` otwórz w pionowym splicie, `<Esc>` zamknij.

| Co | Skrót |
| --- | --- |
| plik po nazwie | `<leader>ff` |
| tekst w całym projekcie (wymaga `rg`) | `<leader>fg` |
| tekst w bieżącym pliku | `<leader>/` |
| otwarte bufory | `<leader>fb` |
| `:help` | `<leader>fh` |
| TODO / FIXME / HACK w projekcie | `<leader>fd` |
| symbol w pliku / w projekcie (LSP) | `<leader>fs` / `<leader>fw` |
| użycia symbolu (LSP) | `<leader>fr` |

**Oil** (`<leader>ft`) pokazuje katalog jako zwykły bufor: zmiana nazwy to edycja
linii, usunięcie to `dd`, nowy plik to nowa linia. Zmiany wykonuje dopiero `:w`.
`-` idzie katalog wyżej.

**Po strukturze kodu (treesitter):** `]f` / `[f` przeskakują do następnej / poprzedniej
funkcji, `]c` / `[c` do klasy. `<C-Space>` zaczyna zaznaczać węzeł składni; kolejne
`<C-Space>` rozszerza zaznaczenie, `<BS>` je zmniejsza. Działa tylko w językach,
dla których jest zainstalowany parser (zob. [Troubleshooting](#10-troubleshooting)).

**Okna:** `<leader>v` pionowy split, `<C-h>` / `<C-l>` przejście w lewo / prawo,
`<leader>,` / `<leader>.` zwężenie / poszerzenie.

---

## 3. Formatowanie i LSP

### Co robi co

| Element | Rola | Gdzie ustawione |
| --- | --- | --- |
| **mason** | instaluje binarki serwerów, formatterów i debuggerów do `~/.local/share/nvim/mason/bin` | `plugins/lsp.lua` |
| **nvim-lspconfig** | dostarcza gotowe konfiguracje serwerów (`cmd`, `filetypes`, `root_markers`) | pakiet, bez setupu |
| **`vim.lsp.enable({...})`** | włącza serwery; bez wpisu na tej liście serwer się nie uruchomi | `plugins/lsp.lua` |
| **`lsp/<nazwa>.lua`** | moje ustawienia serwera, doklejane do konfiguracji z lspconfig | `lsp/roslyn.lua` |
| **roslyn.nvim** | serwer C# (Roslyn); jego binarkę daje mason z dodatkowego rejestru Crashdummyy | `plugins/lsp.lua` |
| **conform** | formatowanie: `clang-format` dla C/C++/C#, `black` dla Pythona; reszta przez LSP | `plugins/formatting.lua` |
| **blink.cmp** | okienko podpowiedzi i podpowiedź sygnatury funkcji | `plugins/completion.lua` |

Włączone serwery: `roslyn` (C#), `clangd` (C/C++), `rust_analyzer`, `pyright`, `lua_ls`,
`html`, `cssls`, `emmet_ls`, `air` (R).

### Skróty LSP

Moje: `<leader>gd` definicja, `<leader>fr` użycia, `<leader>cr` zmiana nazwy,
`<leader>ca` akcje kodu, `<leader>e` błąd pod kursorem, `g[` / `g]` następny /
poprzedni błąd.

Wbudowane w Neovima (działają zawsze, gdy LSP jest podpięty): `K` dokumentacja,
`grn` zmiana nazwy, `gra` akcje, `grr` użycia, `gri` implementacje,
`grt` definicja typu, `gO` symbole, `]d` / `[d` błędy, `<C-s>` (insert) sygnatura.

### Formatowanie

- Przy każdym `:w` automatycznie (limit 500 ms).
- Ręcznie `<leader>cf` formatuje cały plik, a w trybie visual tylko zaznaczenie.
- Nie formatuje się? Uruchom `:ConformInfo`. Pokaże, jaki formatter jest przypisany
  i czy znaleziono jego binarkę.
- Dodanie formattera: wpis w `formatters_by_ft` w `plugins/formatting.lua` oraz
  instalacja przez `:Mason`.

### Jak sprawdzić, czy serwer działa

1. Otwórz plik z kodem i wpisz **`:LspInfo`** (albo `:checkhealth vim.lsp`).
   Sekcja *Active Clients* powinna pokazać serwer i **Root directory**.
2. `Root directory: nil` oznacza, że serwer nie znalazł korzenia projektu
   (Cargo.toml, .git, compile_commands.json, .sln…). Otwórz nvim w katalogu
   projektu.
3. Nie ma żadnego klienta? Sprawdź, czy:
   - serwer jest na liście `vim.lsp.enable` w `plugins/lsp.lua`,
   - binarka jest zainstalowana (`:Mason`),
   - log nie pokazuje błędu (`:LspLog`).
4. Restart serwera: `:LspRestart`. Dla C#: `:Roslyn restart`.

**C (clangd)** w pojedynczym pliku działa bez konfiguracji. Przy projekcie z
Makefile/CMake clangd potrzebuje `compile_commands.json` w katalogu projektu,
inaczej nie zna flag i ścieżek include:
- CMake: `cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -s build/compile_commands.json .`
- Make: `bear -- make` (`brew install bear`).

**C# (roslyn):** potrzebuje pliku `.sln` albo `.csproj` w projekcie. Gdy w katalogu
jest kilka solucji, wybierz jedną przez `:Roslyn target`. Pierwsze uruchomienie
w projekcie trwa kilkanaście sekund.

---

## 4. Nowy projekt w Ruście

```bash
cargo new nazwa && cd nazwa && nvim src/main.rs
```

**Nvim otwieraj w katalogu z `Cargo.toml`.** rust_analyzer szuka korzenia
projektu po `Cargo.toml`. Bez niego `:LspInfo` pokaże `Root directory: nil`,
a podpowiedzi, błędy i skoki nie zadziałają.

- Pierwsze otwarcie projektu indeksuje zależności (paski postępu na dole). Poczekaj,
  zanim uznasz, że LSP „nie działa”.
- Po zmianie `Cargo.toml` (nowa zależność) zapisz plik. Jeśli podpowiedzi dalej
  nie widzą crate'a, użyj `:LspRestart`.
- Formatowanie `.rs` idzie przez LSP (rust_analyzer → rustfmt), bo conform nie ma
  wpisu dla Rusta.
- Treesitter dla Rusta wymaga parsera: `:TSInstall rust`.
- Debugowanie opisuje [sekcja 6](#6-debugowanie-c--c--rust--c-dap).

---

## 5. Kompilacja i skakanie po błędach

Wbudowane `:make` + lista quickfix. Nie potrzeba do tego żadnego pluginu.

| Język | Ustawienie (raz na sesję) | Kompilacja |
| --- | --- | --- |
| C z Makefile | nic, domyślnie `make` | `:make` |
| Rust | `:compiler cargo` | `:make build` (albo `:make check`, `:make test`) |
| C#/.NET | `:set makeprg=dotnet\ build` | `:make` |

Po `:make` błędy trafiają na listę quickfix:

| Co | Jak |
| --- | --- |
| otwórz listę błędów | `:copen` (zamknij `:cclose`) |
| następny / poprzedni błąd | `]q` / `[q` |
| pierwszy / ostatni błąd | `[Q` / `]Q` |
| skok do błędu z listy | `<CR>` na linii w oknie quickfix |

Kompilacja „na żywo” w terminalu: `<leader>tt`, a potem np. `cargo run` albo `make && ./main`.
Wyjście z trybu wpisywania w terminalu: `<C-\><C-n>`.

Nowy `Makefile` dostaje szablon z `skeleton/make.skel` ([sekcja 7](#7-edycja-szablony-snippety-surround-textobjecty)).

---

## 6. Debugowanie C / C++ / Rust / C# (DAP)

**DAP** pozwala zatrzymać program na wybranej linii (breakpoint), iść krok po kroku
i oglądać wartości zmiennych. Po starcie sesji okna dap-ui (zmienne, stos,
breakpointy, konsola) otwierają się same.

| Co | Skrót |
| --- | --- |
| postaw / zdejmij breakpoint w linii | `<leader>b` |
| uruchom / kontynuuj do następnego breakpointu | `<F5>` |
| następna linia (bez wchodzenia do funkcji) | `<F9>` |
| wejdź do funkcji / wyjdź z funkcji | `<F11>` / `<F12>` |
| zakończ sesję | `:DapTerminate` |
| zamknij okna dap-ui | `:lua require('dapui').close()` |

Na macOS `F11` i `F12` mogą być przechwytywane przez system (Mission Control,
pulpit). Wyłącz to w *Ustawienia systemowe → Klawiatura → Skróty klawiszowe*
albo użyj `fn+F11`.

### C / C++ (codelldb)

1. Kompiluj **z `-g`** (bez tego nie ma informacji o liniach):
   `gcc -g -o main main.c`. Szablon Makefile ma już `-g`.
2. Otwórz nvim w katalogu projektu. Program jest szukany kolejno w `build/main`,
   `bin/main` i `./main`. Jeśli go tam nie ma, nvim zapyta o ścieżkę.
3. `<leader>b` na wybranej linii, potem `<F5>`. Konfiguracja C zatrzymuje się
   najpierw na wejściu do programu (`stopOnEntry`). Kolejne `<F5>` idzie do
   breakpointu.

### Rust (codelldb)

1. `cargo build` (profil debug jest domyślny).
2. Nvim otwarty w katalogu z `Cargo.toml`. Program jest brany z
   `target/debug/<name z Cargo.toml>`; jeśli go nie ma, nvim zapyta o ścieżkę.
3. `<leader>b`, potem `<F5>`. Zatrzyma się dopiero na breakpoincie.

### C# (netcoredbg)

1. `dotnet build`.
2. Nvim otwarty w katalogu projektu (tam, gdzie `.csproj`). DLL jest szukany
   w `bin/Debug/net*/`: najpierw ten o nazwie katalogu, inaczej pierwszy
   znaleziony. Jeśli żadnego nie ma, nvim zapyta.
3. `<leader>b`, potem `<F5>`.

Przy okazji .NET: `<leader>dr` wkleja w bieżącej linii `.csproj` blok
`<Reference>` dla wskazanego pliku DLL.

### Gdy debugger nie startuje

- `Couldn't connect to 127.0.0.1:${port}` albo „Debug adapter didn't respond”
  przy **pierwszym** uruchomieniu to zwykle macOS sprawdzający binarkę codelldb.
  Spróbuj jeszcze raz.
- Czy codelldb jest zainstalowany: `:Mason` (szukaj `codelldb`).
- Log: `:DapShowLog`. Więcej szczegółów: `:lua require('dap').set_log_level('TRACE')`.
- Konfiguracje są w `lua/bartus/plugins/debug.lua` (`dap.configurations.<język>`).

---

## 7. Edycja: szablony, snippety, surround, textobjecty

**Szablony nowych plików (skel-nvim).** Nowy, pusty `*.c`, `*.cpp`, `*.hpp` albo
`Makefile` dostaje treść z `skeleton/`. Nowy szablon: dodaj plik
`skeleton/<nazwa>.skel` i wpis w `mappings` w `plugins/editing.lua`.
Komendy: `:SkelDisable`, `:SkelEnable`, `:SkelRun`.

**Snippety.** `snippets/<filetype>.json` w formacie VS Code. Dla C# `///` rozwija
komentarz `<summary>`. Po rozwinięciu `<Tab>` / `<S-Tab>` skacze między polami.

**Podpowiedzi (blink.cmp).**

| Skrót | Działanie |
| --- | --- |
| `<C-Space>` | pokaż menu lub dokumentację |
| `<Tab>` / `<S-Tab>`, `<C-n>` / `<C-p>` | następna / poprzednia podpowiedź |
| `<CR>` albo `<C-y>` | akceptuj |
| `<C-e>` | zamknij menu |

Przy zamkniętym menu `<Tab>` skacze w snippecie albo wychodzi za `)`, `]`, `}`,
`"` lub `'`.

**Nawiasy** domykają się same (pear-tree).

**Surround (vim-surround):**

| Skrót | Działanie |
| --- | --- |
| `ysiw"` | otocz słowo `"` |
| `cs"'` | zamień `"` na `'` |
| `ds(` | usuń nawiasy |
| `S)` w visual | otocz zaznaczenie |

**Textobjecty** (działają z `d`, `c`, `y`, `v`):

| Skrót | Obejmuje |
| --- | --- |
| `af` / `if` | funkcja / ciało funkcji |
| `ac` / `ic` | klasa / ciało klasy |
| `aa` / `ia` | parametr z przecinkiem / sam parametr |
| `aq` / `iq` | `"…"` z cudzysłowami / wnętrze |

Przykłady: `dif` czyści ciało funkcji, `cia` zmienia argument.

**Komentarze** (wbudowane): `gcc` przełącza komentarz w linii, `gc` w visual
przełącza dla zaznaczenia.

**TODO:** `TODO:`, `FIXME:`, `HACK:` i `NOTE:` w komentarzach są podświetlane.
Lista wszystkich wystąpień w projekcie: `<leader>fd`.

---

## 8. Jak zmienić config

**Nowy plugin:**
1. Dodaj `{ src = "https://github.com/autor/plugin" }` w `lua/bartus/pack.lua`.
2. Setup i skróty umieść w pasującym pliku `lua/bartus/plugins/<dziedzina>.lua`
   albo w nowym pliku, dopisanym do `init.lua`.
3. Uruchom ponownie nvim. `vim.pack` sam ściągnie plugin.

**Usunięcie pluginu:** usuń wpis z `pack.lua` i jego setup, potem
`:lua vim.pack.del({ 'nazwa-katalogu' })`, żeby skasować go z dysku.
**Aktualizacja pluginów:** `:lua vim.pack.update()`.

**Nowy serwer LSP:**
1. Znajdź nazwę konfiguracji: jest to nazwa pliku w katalogu lspconfig
   (np. `ts_ls`, `gopls`). Katalog otworzysz w Oil przez
   `:e ~/.local/share/nvim/site/pack/core/opt/nvim-lspconfig/lsp/`.
   Lista z opisami: `doc/configs.md` w repo nvim-lspconfig.
2. Zainstaluj binarkę przez `:Mason`.
3. Dopisz nazwę do `vim.lsp.enable({...})` w `plugins/lsp.lua`.
4. Własne ustawienia serwera umieść w `lsp/<nazwa>.lua` (jak `lsp/roslyn.lua`),
   jako `return { settings = { ... } }`.

**Nowy skrót:** zawsze z `desc` po polsku, w trybie rozkazującym:
```lua
vim.keymap.set('n', '<leader>xy', fn, { desc = 'Zrób coś' })
```
Nowa grupa `<leader>x` wymaga wpisu w `wk.add` w `plugins/ui.lua`. Potem
`:KeymapsDoc`, żeby odświeżyć KEYMAPS.md.

**Szybki test po zmianie:** `nvim --headless +qa` nie powinno nic wypisać.
Skrót `<leader>o` zapisuje i wczytuje bieżący plik (`:source`), co wystarcza do
testu zmian w jednym module. Zmiany w `init.lua` i `pack.lua` wymagają restartu.

---

## 9. Instalacja od zera na nowym Macu

```bash
# 1. narzędzia systemowe
xcode-select --install                     # git, clang, lldb
brew install bob ripgrep node dotnet       # rg: <leader>fg, node: część serwerów z masona
curl https://sh.rustup.rs -sSf | sh        # Rust (cargo, rustfmt)

# 2. Neovim nightly (vim.pack wymaga 0.12)
bob install nightly && bob use nightly
# dopisz do PATH w ~/.zshrc:
#   export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# 3. config
git clone <adres-repo> ~/.config/nvim

# 4. pierwsze uruchomienie: vim.pack instaluje pluginy (potwierdź)
nvim
```

W Neovimie:

```vim
" serwery, formattery, debugger (rejestr Crashdummyy jest już w configu, stąd roslyn)
:MasonInstall clangd rust-analyzer roslyn pyright lua-language-server html-lsp css-lsp emmet-ls air clang-format black codelldb

" parsery treesitter
:TSInstall c cpp rust c_sharp lua python markdown markdown_inline vim vimdoc query

:checkhealth
```

Debugger C# (netcoredbg dla arm64) jest dołączony do pluginu
`netcoredbg-macOS-arm64.nvim`, więc nie trzeba go instalować osobno.

---

## 10. Troubleshooting

| Objaw | Co sprawdzić |
| --- | --- |
| coś ogólnie nie działa | `:checkhealth` (albo zawężone: `:checkhealth vim.lsp`, `:checkhealth nvim-treesitter`) |
| błąd przy starcie | `:messages`; z terminala `nvim --headless +qa` pokaże błąd |
| brak podpowiedzi, błędów, `gd` | `:LspInfo`: czy jest klient i jaki ma **Root directory**, zob. [sekcja 3](#jak-sprawdzić-czy-serwer-działa) |
| `Root directory: nil` | nvim otwarty poza projektem (Rust: [sekcja 4](#4-nowy-projekt-w-ruście)) |
| serwer się wysypał albo zawiesił | `:LspLog` (plik `~/.local/state/nvim/lsp.log`), potem `:LspRestart` |
| brak kolorowania składni, `]f` / `af` nie działają | brak parsera: `:TSInstall <język>`, lista zainstalowanych: `:TSInstallInfo` |
| nie formatuje przy `:w` | `:ConformInfo` |
| debugger nie startuje | [sekcja 6 → Gdy debugger nie startuje](#gdy-debugger-nie-startuje) |
| skąd jest dany skrót | `:verbose map <skrót>`, np. `:verbose nmap <Space>ff` |
| brakuje binarki serwera lub formattera | `:Mason` (`i` instaluje, `X` odinstalowuje, `U` aktualizuje) |
| `<leader>fg` nic nie znajduje | czy jest `rg`: `which rg` |

Logi i dane:

| Co | Gdzie |
| --- | --- |
| log LSP | `~/.local/state/nvim/lsp.log` |
| pluginy | `~/.local/share/nvim/site/pack/core/opt/` |
| binarki masona | `~/.local/share/nvim/mason/bin/` |
