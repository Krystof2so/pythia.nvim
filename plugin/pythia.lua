vim.api.nvim_create_user_command("PythiaProject", function()
   require("pythia").setup()
end, { desc = "Nom du projet Python" })

