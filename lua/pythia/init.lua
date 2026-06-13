local M = {}

--- Initialise le plugin
function M.setup()
	-- Initialise les commandes
	require("pythia.core.commands").setup()

	-- Initialise les keymaps
	require("pythia.core.keymaps").setup()

	-- Initialise les autocmds
	require("pythia.core.autocmd").setup()
end

return M
