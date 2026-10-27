---@type 183.Options
---@diagnostic disable-next-line: missing-fields
local M = {}

-- plugins
M.plugins = {}

-- lsp server config
M.lsps = {
    lua_ls = {},
    svelte = {},
    jdtls = {},
    fish_lsp = {},
    clangd = {},
    basedpyright = {},
    tailwindcss = {},
    emmet_language_server = {},
    css_variables = {},
    csskit = {},
    cssmodules_ls = {},
    html = {},
    jsonls = {},
}

-- :h conform-formatters
-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md
M.formatters = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "htmlbeautifier", "prettier" },
    c = { "clang-format" },
    svelte = { "prettier" },
    fish = { "fish_indent" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { --[[ "fixjson", "jq", ]]
        "prettier",
    },
    jsonc = { --[[ "fixjson", "jq", ]]
        "prettier",
    },
    python = { "isort", "ruff_fix", "ruff_format" },
}
M.custom_formatters = {}

-- https://github.com/mfussenegger/nvim-lint#available-linters
M.linters = {
    python = { "ruff" },
    json = { "jsonlint" },
    html = { "htmlhint" },
}
M.custom_linters = {}

-- dap configuration
local mason_path = vim.fn.expand("$MASON")
local codelldb = {
    name = "launch executable",
    type = "codelldb",
    request = "launch",
    program = function()
        return vim.fn.input(
            "executable: ",
            vim.fn.getcwd() .. "/",
            "file"
        )
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
}
M.dap = {
    codelldb = {
        adapter = {
            type = "executable",
            command = FUNCS.join_path(
                mason_path,
                "bin",
                "codelldb"
            ),
        },

        configs = {
            c = { codelldb },
            cpp = { codelldb },
        },
    },
}

-- neotest adapter configuration
-- https://github.com/nvim-neotest/neotest#supported-runners
M.test = {
    ["neotest-ctest"] = {
        link = "https://github.com/orjangj/neotest-ctest",
        adapter = function()
            return require("neotest-ctest").setup({
                dap_adapter = "codelldb",
            })
        end,
    },
}

-- additional filetypes
M.filetypes = {
    {
        extension = {
            license = "",
        },
        filename = {
            ["license"] = "license",
            ["LICENSE"] = "license",
        },
    },
}

-- treesitter parsers
M.parsers = {}

-- visual obfuscation
M.cloak = {
    {
        file_pattern = { ".env", ".env.*" },
        cloak_pattern = { "=.+" },
        replace = nil,
    },
    {
        file_pattern = { "*secret.json", "secret*.json" },
        cloak_pattern = { ":.+" },
        replace = nil,
    },
}

M.leetpath = "/home/anir183/workspace/sandbox/leetcode"

return M
