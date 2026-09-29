-- Ikony plików i typów (mini.icons) dla telescope, oil, lualine, which-key.
-- Brak keymapów. Ładowany przed innymi pluginami, żeby widziały ikony od startu.
-- Zależy od: mini.icons; terminal z symbolami Nerd Font (Ghostty ma je wbudowane).

require("mini.icons").setup()
-- pluginy, które szukają nvim-web-devicons (telescope, oil, lualine), dostaną mini.icons
MiniIcons.mock_nvim_web_devicons()
