-- Punkt wejścia configu: tylko require'y, zero logiki.
-- Kolejność ma znaczenie: opcje (i <leader>) → instalacja pluginów → reszta.
-- Mapa plików i „jak zrobić X”: README.md, lista skrótów: KEYMAPS.md.

require("bartus.core.options")
require("bartus.pack")
require("bartus.core.keymaps")
require("bartus.core.autocmds")
require("bartus.core.keymaps_doc")

require("bartus.plugins.icons")
require("bartus.plugins.find")
require("bartus.plugins.treesitter")
require("bartus.plugins.editing")
require("bartus.plugins.completion")
require("bartus.plugins.formatting")
require("bartus.plugins.lsp")
require("bartus.plugins.debug")
require("bartus.plugins.git")
require("bartus.plugins.ui")
require("bartus.plugins.preview")
require("bartus.plugins.notebook")
