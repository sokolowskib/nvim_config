-- Punkt wejścia configu: tylko require'y, zero logiki.
-- Kolejność ma znaczenie: opcje (i <leader>) → instalacja pluginów → reszta.
-- Mapa plików i „jak zrobić X”: README.md.

require("sokolowskib.core.options")
require("sokolowskib.pack")
require("sokolowskib.core.keymaps")
require("sokolowskib.core.autocmds")

require("sokolowskib.plugins.icons")
require("sokolowskib.plugins.find")
require("sokolowskib.plugins.treesitter")
require("sokolowskib.plugins.editing")
require("sokolowskib.plugins.completion")
require("sokolowskib.plugins.formatting")
require("sokolowskib.plugins.lsp")
require("sokolowskib.plugins.debug")
require("sokolowskib.plugins.git")
require("sokolowskib.plugins.ui")
require("sokolowskib.plugins.preview")
require("sokolowskib.plugins.notebook")
