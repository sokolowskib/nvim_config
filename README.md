# nvim

Mój config Neovima. Głównie piszę w C, Ruście i C#, czasem Python w notebookach.
Nightly (0.12) z `bob`, macOS na M-ce. Pluginy przez wbudowany `vim.pack`, lazy.nvim
przestał mi być potrzebny, odkąd to weszło do core'a.

`<leader>` to spacja. Jak zapomnę skrótu, to which-key i tak podpowie.

## Struktura

```
init.lua                 same require'y
lsp/roslyn.lua           ustawienia serwera C#
lua/sokolowskib/
  pack.lua               lista pluginów
  core/                  opcje, ogólne keymapy, autocmdy
  plugins/               jeden plik na temat (lsp, debug, find, notebook...)
skeleton/                szablony nowych plików C/C++/Makefile
snippets/                snippety w formacie VS Code
```

Każdy plik w `plugins/` ma na górze 2–3 linijki komentarza: co robi, jakie skróty
zakłada i od czego zależy. Łatwiej mi tak wrócić do czegoś po pół roku.

## Co tu jest

- **Szukanie**: telescope pod `<leader>f`, oil zamiast drzewka plików (`<leader>ft`)
- **LSP**: clangd, rust_analyzer, roslyn, pyright, lua_ls, html/css/emmet, air (R).
  Binarki z masona, roslyn z rejestru Crashdummyy
- **Uzupełnianie**: blink.cmp, Tab wyskakuje za nawias jak nie ma menu
- **Formatowanie**: conform przy zapisie (clang-format, black, reszta przez LSP)
- **Debug**: nvim-dap + dap-ui, codelldb dla C/C++/Rusta, netcoredbg dla C#
- **Notebooki**: `.ipynb` otwiera się jako markdown, komórki odpala molten,
  wykresy renderują się w terminalu
- **Drobiazgi**: szablony nowych plików, surround, textobjecty z treesittera,
  gitsigns, podgląd markdowna

## Skróty, które faktycznie używam

| | |
| --- | --- |
| `<leader>ff` / `<leader>fg` | plik / grep po projekcie |
| `<leader>gd` / `<leader>fr` | definicja / użycia |
| `<leader>ca` / `<leader>cr` | code action / rename |
| `<leader>cf` | formatowanie (zaznaczenia też) |
| `<leader>e`, `g[` / `g]` | diagnostyka pod kursorem, następny / poprzedni błąd |
| `<leader>tt` / `<leader>tr` | terminal pod spodem / z prawej |
| `<leader>b`, `<F5>` | breakpoint, start/continue |
| `<F9>` / `<F11>` / `<F12>` | step over / into / out |
| `]f` `[f`, `af` `if` | skoki i textobjecty po funkcjach |
| `<leader>j…` | wszystko od notebooków |

Reszta to domyślne mapy Neovima (`K`, `grn`, `gra`, `]d`...).

## Debugowanie

Konfiguracje szukają binarki same, więc nie muszę za każdym razem wpisywać ścieżki:

- **C/C++**: `build/main`, `bin/main` albo `./main`. Kompilować z `-g`
  (szablon Makefile już to ma).
- **Rust**: `target/debug/<nazwa z Cargo.toml>`, po `cargo build`.
- **C#**: DLL z `bin/Debug/net*/`, po `dotnet build`.

Jak nic nie znajdzie, pyta o ścieżkę. Na macOS F11/F12 zjada system, trzeba
wyłączyć w ustawieniach klawiatury albo jechać z `fn`.

Pierwsze odpalenie codelldb często kończy się timeoutem (Gatekeeper skanuje binarkę),
drugi raz już działa.

## Rzeczy, o które się potknąłem

- rust_analyzer i roslyn chcą, żeby nvim był otwarty w katalogu projektu
  (z `Cargo.toml` / `.sln`). Inaczej `Root directory: nil` i nic nie działa.
- Pierwsze otwarcie projektu w Ruście czy C# to kilkanaście sekund indeksowania,
  zanim `gd` zacznie odpowiadać.
- clangd przy większym projekcie potrzebuje `compile_commands.json`:
  `bear -- make` albo `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` w CMake'u.
- Obrazki z notebooków w tmuxie wymagają `allow-passthrough on`.
- Jak coś się sypie przy starcie: `nvim --headless +qa` pokazuje błąd bez UI.

## Instalacja

```bash
xcode-select --install
brew install bob ripgrep node dotnet imagemagick python@3.13
curl https://sh.rustup.rs -sSf | sh

bob install nightly && bob use nightly
git clone https://github.com/sokolowskib/nvim_config ~/.config/nvim

# venv dla notebooków
python3.13 -m venv ~/.virtualenvs/neovim
~/.virtualenvs/neovim/bin/pip install pynvim jupyter_client ipykernel jupytext nbformat matplotlib pillow
~/.virtualenvs/neovim/bin/python -m ipykernel install --user --name python3
mkdir -p ~/Library/Jupyter/runtime

nvim   # vim.pack sam ściągnie pluginy
```

Potem w środku:

```vim
:MasonInstall clangd rust-analyzer roslyn pyright lua-language-server html-lsp css-lsp emmet-ls air clang-format black codelldb
:TSInstall c cpp rust c_sharp lua python markdown markdown_inline vim vimdoc query
```

netcoredbg dla arm64 przychodzi z pluginem, nie trzeba go instalować osobno.
