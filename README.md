# nvim

My Neovim config. I mostly write C, Rust and C#.
Nightly (0.12) via `bob`, macOS on Apple Silicon. Plugins go through the built-in
`vim.pack`, I stopped needing lazy.nvim once that landed in core.

`<leader>` is space. If I forget a mapping, which-key reminds me anyway.

## Layout

```
init.lua                 just requires
lsp/roslyn.lua           C# server settings
lua/sokolowskib/
  pack.lua               plugin list
  core/                  options, general keymaps, autocmds
  plugins/               one file per topic (lsp, debug, find...)
skeleton/                templates for new C/C++/Makefile files
snippets/                VS Code style snippets
```

Every file in `plugins/` starts with a 2–3 line comment: what it does, which
mappings it sets and what it depends on. Makes it easier to come back to
something after half a year.

## What's in here

- **Finding stuff**: telescope under `<leader>f`, oil instead of a file tree (`<leader>ft`)
- **LSP**: clangd, rust_analyzer, roslyn, pyright, lua_ls.
- **Completion**: blink.cmp, 
- **Formatting**: conform on save (clang-format, black, LSP for the rest)
- **Debugging**: nvim-dap + dap-ui, codelldb for C/C++/Rust, netcoredbg for C#
- **Small things**: new file templates, surround, treesitter textobjects,
  gitsigns, markdown preview

## Mappings I actually use

| | |
| --- | --- |
| `<leader>ff` / `<leader>fg` | find file / grep the project |
| `<leader>gd` / `<leader>fr` | definition / references |
| `<leader>ca` / `<leader>cr` | code action / rename |
| `<leader>cf` | format (works on a selection too) |
| `<leader>e`, `g[` / `g]` | diagnostic under cursor, next / previous error |
| `<leader>tt` / `<leader>tr` | terminal below / on the right |
| `<leader>b`, `<F5>` | breakpoint, start/continue |
| `<F9>` / `<F11>` / `<F12>` | step over / into / out |
| `]f` `[f`, `af` `if` | jump between functions, function textobjects |


## Debugging

The configs find the binary on their own, so I don't have to type a path every time:

- **C/C++**: `build/main`, `bin/main` or `./main`. Compile with `-g`
  (the Makefile template already does).
- **Rust**: `target/debug/<name from Cargo.toml>`, after `cargo build`.
- **C#**: the DLL from `bin/Debug/net*/`, after `dotnet build`.

If nothing is found, it asks for a path. On macOS the system grabs F11/F12, so
either turn that off in keyboard settings or hold `fn`.

The first codelldb run often times out (Gatekeeper scanning the binary),
the second one works.

## Things I tripped over

- rust_analyzer and roslyn want nvim opened in the project directory
  (with `Cargo.toml` / `.sln`). Otherwise it's `Root directory: nil` and nothing works.
- Opening a Rust or C# project for the first time means a dozen or so seconds
  of indexing before `gd` starts responding.

## Install

```bash
xcode-select --install
brew install bob ripgrep node dotnet
curl https://sh.rustup.rs -sSf | sh

bob install nightly && bob use nightly
git clone https://github.com/sokolowskib/nvim_config ~/.config/nvim

nvim   # vim.pack pulls the plugins by itself
```

Then inside:

```vim
:MasonInstall clangd rust-analyzer roslyn pyright lua-language-server html-lsp css-lsp emmet-ls air clang-format black codelldb
:TSInstall c cpp rust c_sharp lua python markdown markdown_inline vim vimdoc query
```

netcoredbg for arm64 ships with its plugin, no separate install needed.
