return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI for beautiful debug layout
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      -- Delve wrapper for Go support
      "leoluz/nvim-dap-go",
      -- Virtual text for inline variable values
      "theHamsta/nvim-dap-virtual-text",
      -- Bridge between mason and dap
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      -- Debug control keys
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      
      -- Breakpoints and UI
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Set Conditional Breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last Session" },
      
      -- Go specific DAP keys
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Debug: Go Test Under Cursor" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup dap-ui with default options
      dapui.setup()

      -- Setup dap-go with default options (looks for 'dlv' in PATH)
      require("dap-go").setup()

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        commented = true, -- prefix virtual text with comment string
      })

      -- Setup mason-nvim-dap for managing debug adapters automatically
      require("mason-nvim-dap").setup({
        -- Makes a best effort to setup adapters for common languages
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          -- delve is installed for go
          "delve",
        },
      })

      -- Automatically open/close DAP-UI during active sessions
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
