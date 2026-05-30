local M = {}

function M.setup()
	local project_name = vim.fn.input("Nom du projet Python à créer : ")
	if project_name ~= "" then
		vim.notify("Ok, le projet " .. project_name .. " va être créé", vim.log.levels.INFO)
	end
end

return M
