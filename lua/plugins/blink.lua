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
        -- Pin to the v1 line. Tracking main pulls the v2 dev branch, which
        -- requires the extra 'saghen/blink.lib' dependency and errors on load.
        -- No 'build' step: v1 ships prebuilt fuzzy matchers for both glibc and
        -- musl, so this needs no Rust toolchain on any distro.
        version = "1.*",
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
