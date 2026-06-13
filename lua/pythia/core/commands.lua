-- Centralise les commandes

local M = {}

--- Initialise toutes les commandes du plugin
function M.setup()
	local project = require("pythia.project")

	-- Commande :PythiaNewProject
	vim.api.nvim_create_user_command("PythiaNewProject", function()
		project.create_project()
	end, { desc = "Demande le nom d'un projet Python" })

	-- ajoute des autres commandes...
end

return M
