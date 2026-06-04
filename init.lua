vim.g.mapleader = " "                              -- Set leader key to space
vim.g.maplocalleader = " "                         -- Set local leader key (NEW)

require("config.lazy")
require("options")
require("autocmds")
require("keymap")
