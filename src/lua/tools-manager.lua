-- NOTE: this just sets up the installer, but does not install anything.
-- The tools are installed in their respective tooling files,
-- e.g. LSPs are installed in lsp.lua

local mason = require('mason')

mason.setup {}
