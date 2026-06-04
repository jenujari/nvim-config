return {
    {
        "L3MON4D3/LuaSnip",
        config = function()
            -- Yahan syntax error thi, maine '.lazy_load()' add kar diya hai
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
    { "rafamadriz/friendly-snippets" },
    {
        "Saghen/blink.cmp",
        -- 'version' tag add karne se pre-built binary download hoti hai 
        -- aur 'build' function ki zaroorat nahi padti.
        version = "*",
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
        opts = {
            fuzzy = { implementation = "rust" },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                menu = {
                    auto_show = true,
                    draw = {
                        treesitter = { "lsp" },
                        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
                    },
                },
            }
        },
    },
}
