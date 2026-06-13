-- Création gestion de projet

local M = {}

--- Crée un nouveau projet Python
function M.create_project()
  local project_name = vim.fn.input("Nom du projet Python à créer : ")
  if project_name and project_name ~= "" then
    vim.notify("Ok, le projet " .. project_name .. " va être créé", vim.log.levels.INFO)
    -- TODO: ajouter la logique de création de l'environnement avec répertoires et fichiers, etc.
  end
end

return M
