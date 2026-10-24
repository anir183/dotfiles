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
}

-- :h conform-formatters
-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md
M.formatters = {
    lua = { "stylua" },
}
M.custom_formatters = {}

-- https://github.com/mfussenegger/nvim-lint#available-linters
M.linters = {}
M.custom_linters = {}

-- dap configuration
M.dap = {}

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
