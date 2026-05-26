# `pythia.nvim` — Feuille de route

>[!IDEA] 💡 _"The Python oracle for Neovim"_

## Conception d’un plugin <mark style="background: #D2B3FFA6;">Neovim</mark> unifié pour le développement <mark style="background: #D2B3FFA6;">Python</mark>

Le développement [[Python]] dans [[Neovim]] est [souvent fragmenté entre plusieurs *plugins* spécialisés](https://www.playfulpython.com/configuring-neovim-as-a-python-ide/), chacun apportant une partie des fonctionnalités attendues d’un IDE moderne : gestion de projets, détection des environnements virtuels, intégration du *Language Server
Protocol* (**LSP**), navigation dans le code, exécution des tests, et installation des dépendances. Cette fragmentation complique la configuration et la maintenance, et limite l’expérience utilisateur en imposant une coordination manuelle entre ces outils. Un *plugin* <mark style="background: #D2B3FFA6;">Neovim</mark> unifié pour <mark style="background: #D2B3FFA6;">Python</mark> doit proposer une gestion automatiser des outils de développement pour un écosystème de développement consacré au langage <mark style="background: #D2B3FFA6;">Python</mark>, tout en masquant la complexité de la coordination afin de présenter un environnement de développement "clé en main", tout en restant léger et performant.

### Ce que devra proposer le *plugin*

- Il sera nécessaire d'implémenter une gestion de projet à l'instar de ce qui pouvait être proposé par [pyflowenv.nvim](https://github.com/Krystof2so/pyflowenv-nvim).
- L'ntégration d'outils comme [snacks.nvim](https://github.com/folke/snacks.nvim) et/ou [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) doit pouvoir proposer une expérience utilisateur fluide.
- L’activation automatique de [pyright](https://github.com/microsoft/pyright) (**LSP**) et des *linters* comme [Ruff](https://docs.astral.sh/ruff/linter/), ainsi que l’intégration de [neotest](https://github.com/nvim-neotest/neotest) pour les tests, apparaissent essentielles pour un *workflow* complet.
- La gestion des environnements virtuels ([venv, Poetry, uv](https://github.com/Krystof2so/Python_virtual_tuto)) et l’installation de paquets via un outil comme [LazyDeveloperHelper](https://github.com/LazyDeveloperHelper/LazyDeveloperHelper/) doivent être orchestrées pour réduire la complexité utilisateur.
- Le *plugin* unifié doit s’appuyer sur une architecture modulaire qui orchestrerait les fonctionnalités des *plugins* existants, en masquant la complexité de leurs interactions.
- Une documentation riche (Français/anglais)

### Avantages d'un *plugin* unifié

- Cohérence dans le flux de travail
- Réduction de la configurations manuelle (l'idée d'un outil prêt à l'emploi)
- Optimisation pour les projets développés en <mark style="background: #D2B3FFA6;">Python</mark>
- Intégration native à <mark style="background: #D2B3FFA6;">Neovim</mark> 

---

## 0 - Prérequis

Acquérir des connaissances sur l'environnement <mark style="background: #D2B3FFA6;">Neovim</mark>/[[Lua]] et le développement de *plugins* pour <mark style="background: #D2B3FFA6;">Neovim</mark>  s'impose :

- **Le Guide Lua officiel de Neovim** accessible via `:h lua-guide`. Ce guide pose les bases différentes couches de l'API (**Vim**, **Nvim**, **Lua**). Il montre également comment exécuter du code, gérer les options, les auto-commandes et les _keymaps_.
- **Le manuel de référence Lua** accessible via `:h luaref`.
- **Le Guide de Développement de Plugins Lua** accessible via `:h lua-plugin`. Guide spécifiquement conçu pour la création de _plugins_. C'est la référence technique pour structurer le projet.
- [Build a Neovim plugin in Lua - Max Shen](https://dev.to/m4xshen/building-a-neovim-plugin-in-lua-54j9) : guide pour démarrer le développement d'un _plugin_.
- [Develop a Neovim plugin in Lua — Max Shen](https://m4xshen.dev/posts/develop-a-neovim-plugin-in-lua) : guide court et précis.
- [Write a Neovim Plugin with Lua - Nathaniel Stickman](https://www.linode.com/docs/guides/write-a-neovim-plugin-with-lua/) : idéal pour bien comprendre les concepts sous-jacents. Développement d'un exemple concret tout en détaillant le rôle de chaque élément d'un _plugin_.
- [How I Developed My First Neovim Plugin: A Step-by-Step Guide - Gonçalo Alves](https://dev.to/iamgoncaloalves/how-i-developed-my-first-neovim-plugin-a-step-by-step-guide-1lcb) : ce guide montre comment configurer un environnement de développement et explique en détail la structure d'un projet de _plugin_ (les répertoires `plugin/` et `lua/` et leurs rôles respectifs)
- [nvim-best-practices](https://github.com/lumen-oss/nvim-best-practices/tree/main) : il s'agit d'une collection de bonnes pratiques pour le développement moderne de _plugins_ en **Lua**.
- [speniti/neovim-lua-plugin](https://github.com/speniti/neovim-lua-plugin/tree/main) : le dépôt est organisé en fichiers thématiques pour couvrir tous les aspects du développement de _plugins_ **Neovim** en **Lua**.
- L'environnement de script Lua intégré à Neovim, la bibliothèque standard vim et les API associées, accessible via `h: vim.api`.

Nous pouvons ensuite nous attaquer concrètement à la réalisation de ce projet...

---

## 1 - Initialisation du projet et environnement de développement

### 1.1 L'infrastructure collaborative

- ✅ **Créer le dépôt <mark style="background: #D2B3FFA6;">GitHub</mark>** : 
	1. Sur <mark style="background: #D2B3FFA6;">GitHub</mark> : **New repository** → nom `pythia.nvim`, visibilité publique, sans `README` (Création en local).
	2. Cloner le *repos* distant en local

- **Générer la structure** (Architecture, arborescence)
	Suggestion :

```txt
pythia.nvim/
├── lua/
│   ├── pythia/
│   │   ├── init.lua          ← point d'entrée : M.setup(opts)
│   │   ├── config.lua        ← valeurs par défaut des opts
│   │   ├── env.lua           ← détection des environnements
│   │   ├── lsp.lua           ← configuration Pyright + Ruff
│   │   ├── project.lua       ← création/gestion de projets
│   │   ├── ui.lua            ← interface snacks.nvim/Telescope
│   │   └── tests_runner.lua  ← intégration neotest
│   └── core/
│       ├── commands.lua      ← commandes :PythiaXxxx
│       ├── keymaps.lua       ← définition des mappings
│       └── autocmd.lua       ← les autocommandes
├── plugin/
│   └── pythia.lua            ← chargement automatique
├── doc/
│   └── pythia.txt            ← documentation (vimdoc)
├── tests/                    ← tests unitaires
├── LICENSE
├── CONTRIBUTING.md
└── README.md
```

Voir des exemples d'architecture comme :
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim/tree/main)
- [noice.nvim](https://github.com/folke/noice.nvim/tree/main)
- [barbar.nvim](https://github.com/romgrk/barbar.nvim/tree/master)

- **Configurer** `.gitignore`

### 1.2 Premiers fichiers `.lua`

Codage du minimum, qui évoluera par la suite au cours du développement du *plugin*

- `lua/pythia/config.lua` : table des valeurs par défaut qui s'enrichira au fur et à mesure du développement des fonctionnalités. Il faudra y prévoir la fusion des valeurs par défaut avec celles que sélectionnera l'utilisateur.

- `lua/pythia/init.lua` : point d'entrée unique que l'utilisateur appelle via `require("pythia").setup({})`. Par la suite, sera le chef d'orchestre du *plugin* en appelant l'initialisation des modules. Toute la logique métier devra demeurer dans des fichiers dédié, ce fichier assurant juste la coordination.

- `plugin/pythia.lua`  : *plugin* a exécuter au démarrage. Chargement automatique <mark style="background: #D2B3FFA6;">Neovim</mark>, garde-fou, et délégation. Il appelle `require("pythia").setup()` si l'utilisateur n'utilise pas [lazy.nvim](https://lazy.folke.io/)

- `doc/pythia.txt` : quelques lignes de présentation (le titre et une courte description). Suffisant pour que `:help pythia` retourne quelque chose. Par la suite, il documentera chaque commande utilisateur, chaque option de configuration (avec type, valeur par défaut et description), et chaque événement publié. La documentation doit évoluer en parallèle du code, idéalement dans le même *commit* que la fonctionnalité qu'elle décrit.

- `/core/keymaps.lua` (ou `commands.lua`) : définit et enregistre toutes les commandes utilisateur et les *mappings* clavier. C'est ce module qui contient les appels à `vim.api.nvim_create_user_command` et `vim.keymap.set`. Il est appelé par `init.lua` au moment du `setup()`.

### 1.3 - Configuration en mode *dev* (pour tout le monde)

Configuration à effectuer par chacun une seule fois.

- **Cloner le dépôt** dans un environnement approprié :

```zsh
# Chacun sa route...Chacun son chemin...🎶
mkdir -p ~/projects
git clone ...github.../pythia.nvim.git ~/projects/pythia.nvim
```

- **Déclaration dans <mark style="background: #D2B3FFA6;">lazy.nvim</mark>** , soit dans `~/.config/nvim/init.lua` ou soit dans le fichier qui appelle `require("lazy").setup(...)` :

```lua
require("lazy").setup(plugins, {
  dev = {
    path = "~/projects",       -- dossier parent du plugin en dev
    fallback = false,          -- ne pas télécharger depuis GitHub si absent en local
  },
})
```

- **Ajout d'une entrée au *plugin*** en créant `~/.config/nvim/lua/plugins/pythia.lua`  et en y ajoutant :

```lua
return {
  "pythia.nvim",
  dir = "~/projects/pythia.nvim",  -- chemin absolu vers le clone local
  dev = true,                      -- utilise le dossier local au lieu de GitHub
  lazy = false,                    -- chargement immédiat au démarrage
  config = function()
    require("pythia").setup({
      -- options de test pendant le développement
    })
  end,
}
```

- **Vérification** en ouvrant <mark style="background: #D2B3FFA6;">Neovim</mark> et en lançant <mark style="background: #D2B3FFA6;">Lazy</mark> ( `:Lazy` ). `pythia.nvim` doit apparaître avec le badge `DEV` dans la liste des *plugins*. Vérifier que la notification *pythia.nvim chargé ✓* s'affiche au démarrage.

- ***Workflow* de modification**, après chaque modification d'un fichier au niveau du *plugin* en développement : `:Lazy reload pythia.nvim`

>[!Note]  **Note** 
> Pour les modifications de `plugin/pythia.lua`, un redémarrage complet
> de <mark style="background: #D2B3FFA6;">Neovim</mark> est parfois nécessaire car ce fichier est exécuté avant le gestionnaire de *plugins*.

### 1.4 - Mise en place de [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) pour les tests

`plenary.nvim` propose un *runner* de tests unitaires pour <mark style="background: #D2B3FFA6;">Lua</mark> (et là **Djohner** je compte grandement sur toi 😁) : [busted](https://lunarmodules.github.io/busted/), le framework de tests standard pour <mark style="background: #D2B3FFA6;">Lua</mark>, adaptée à l'environnement <mark style="background: #D2B3FFA6;">Neovim</mark>. Il expose deux commandes :

```zsh
:PlenaryBustedFile tests/pythia/config_spec.lua    ← un seul fichier
:PlenaryBustedDirectory tests/                     ← tous les *_spec.lua
```

Les assertions natives de <mark style="background: #D2B3FFA6;">Lua</mark> (`assert(condition)`) sont rudimentaires. `plenary.nvim` fournit une bibliothèque d'assertions expressives qui produisent des messages d'erreur lisibles en cas d'échec.

Il ne fait pas tout, mais il fournit l'essentiel : un *runner*, la syntaxe <mark style="background: #D2B3FFA6;">busted</mark>, et des assertions lisibles. Je pense (ce que j'ai rapidement lu) que ce sera suffisant tant que les tests portent sur la logique pure (config, détection de fichiers, *parsing*).

- **Ajouter <mark style="background: #D2B3FFA6;">Plenary</mark>** comme dépendance dans `~/.config/nvim/lua/plugins/pythia.lua` :

```lua
return {  
  "pythia.nvim",  
  dir = "~/projects/pythia.nvim",  
  dev = true,  
  lazy = false,  
  dependencies = {  
    "nvim-lua/plenary.nvim",  -- requis pour les tests  
  },  
  config = function()  
    require("pythia").setup({})  
  end,  
}
```

- **Ressources** qui, à mon avis, seront à consulter :
	
	- Documentation officielle de `plenary.nvim` sur les test : [https://github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md](https://github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md)
	- Un article sur les tests de *plugins* **LSP** <mark style="background: #D2B3FFA6;">Neovim</mark> : [https://zignar.net/2022/10/26/testing-neovim-lsp-plugins/](https://zignar.net/2022/10/26/testing-neovim-lsp-plugins/)
	- Voir également ceci : [nvim-lua-plugin-template](https://github.com/nvim-lua/nvim-lua-plugin-template)
	- [How to test with 'mini.test'](How to test with 'mini.test')


### 1.5 La *CI GitHub Actions* (???)

Il s'agit d'un robot de vérification hébergé sur <mark style="background: #D2B3FFA6;">GitHub</mark>  (**CI** pour *Continuous Integration* ). L'idée centrale est que plutôt que de découvrir les *bugs* en fin de développement, on les détecte immédiatement, au moment du `push` ou de la *Pull Request*. 

À chaque fois que quelqu'un pousse du code ou ouvre une *Pull Request*, <mark style="background: #D2B3FFA6;">GitHub</mark> démarre automatiquement une machine virtuelle, exécute les tests du projet, et affiche le résultat : ✓ tout va bien, ou ✗ quelque chose est cassé... C'est ce que j'en ai compris après un rapide survol.

Documentation officielle : [https://docs.github.com/fr/actions](https://docs.github.com/fr/actions)

Devons-nous nous y essayer ?

### 1.6 - Rédiger `CONTRIBUTING.md`

Pour clarifier comment on fonctionne (peut se rédiger à l'usage)

- Prérequis (Outils, versions...)
- *Workflow* (cloner/forker, branches, développement en local, *Pull Request*, etc.)
- [Conventions de *commits*](https://www.conventionalcommits.org/fr/v1.0.0/)
- Style <mark style="background: #D2B3FFA6;">Lua</mark>
- Etc...


### 1.7 - Ressources

Outre, toutes celles déjà citées, en voici d'autres complémentaires :

| Ressources                                            | Ce qu'elle contiennent                                                                                                      |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | *plugin* qui configure correctement <mark style="background: #D2B3FFA6;">LuaLS</mark>                                       |
| `h: lua-guide`                                        | Structure d'un plugin <mark style="background: #D2B3FFA6;">Lua</mark>, *autocommands*, commandes utilisateur... Une bible ! |

----

## 2 - Détection automatique des environnements <mark style="background: #D2B3FFA6;">Python</mark>

- Détection d'un projet en cours
- Détection de l'environnement de développement (versions, `venv`...)
- Commande d'affichage d'informations sur l'état du projet : infos [[Git]], `TODO`, `FIX`, branche, etc...
- Et autres ?

----

## 3 - Configuration automatique du **LSP** (<mark style="background: #D2B3FFA6;">Pyright</mark> + <mark style="background: #D2B3FFA6;">Ruff</mark>) 

- Ecoute de la détection (cf. point 2)
- Configuration de <mark style="background: #D2B3FFA6;">Pyright</mark>
- Configurer <mark style="background: #D2B3FFA6;">Ruff</mark> en désactivant les capacités doubles d'avec <mark style="background: #D2B3FFA6;">Pyright</mark>
- Implémenter un *restart* propre des clients **LSP** lors d'un changement de `venv`
- Commande `:PythiaLspRestart` pour forcer le rechargement

---

## 4 - Création et gestion de projets

 - `:PythiaNewProject` → workflow guidé via `Snacks.input` : nom, répertoire, gestionnaire d'`env` (<mark style="background: #D2B3FFA6;">uv</mark>/<mark style="background: #D2B3FFA6;">venv</mark>/<mark style="background: #D2B3FFA6;">Poetry</mark>), version <mark style="background: #D2B3FFA6;">Python</mark>
 - Création automatique : `pyproject.toml`, `src/<nom>/`, `tests/`, `.gitignore`, `README.md`
 - Création du `venv` via `uv init` ou `python -m venv` selon le choix
 - *Picker* de projets récents (`Snacks.picker` / `Telescope`) avec mémorisation dans un fichier <mark style="background: #D2B3FFA6;">JSON</mark>
- `:PythiaOpenProject` → ouvre un projet depuis la liste et déclenche la détection d'`env` (cf. point 2)

---

## 5 - Interface projet et diagnostics temps réel

- `Explorer` latéral via `Snacks.explorer` avec indicateurs de diagnostics à l'aide des **LSP** activés
- Intégration avec [trouble.nvim](https://github.com/folke/trouble.nvim)
- Notifications via `Snacks.notif` pour les événements importants (`env` détecté, **LSP** prêt, erreurs critiques)

---

## 6 - Intégration des tests avec <mark style="background: #D2B3FFA6;">neotest</mark>

- Configuration de [neotest](https://github.com/nvim-neotest/neotest) avec l'adaptateur `neotest-python`
- Affichage des résultats dans un split via snacks terminal ou le panneau neotest natif

---

## 7 - Gestion des dépendances et *polish* final

- Intégration avec <mark style="background: #D2B3FFA6;">LazyDeveloperHelper</mark> pour `:PythiaInstall <paquet>`
- `:checkhealth pythia` vérifiant que tous les composants sont opérationnels
- Documentation `vimdoc` complète dans `doc/pythia.txt`
- `README` (anglais, français... espagnol ?)

----

## Et là 🍻 🍻 !!










