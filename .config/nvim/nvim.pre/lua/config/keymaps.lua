-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "x" }, "<leader>cP", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })

M = {}

function M.setup_neotest_keymaps()
  return {
    {
      "<leader>ta",
      function()
        require("neotest").run.attach()
      end,
      desc = "Attach",
    },
    {
      "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File",
    },
    {
      "<leader>tA",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files",
    },
    {
      "<leader>tT",
      function()
        require("neotest").run.run({ suite = true })
      end,
      desc = "Run Test Suite",
    },
    {
      "<leader>tn",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show Output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>tt",
      function()
        require("neotest").run.stop()
      end,
      desc = "Terminate",
    },
    {
      "<leader>td",
      function()
        vim.cmd("Neotree close")
        require("neotest").summary.close()
        require("neotest").output_panel.close()
        require("neotest").run.run({ suite = false, strategy = "dap" })
      end,
      desc = "Debug nearest test",
    },

    -- -- map_normal_mode("<leader>td", ':lua require("neotest").run.run({vim.fn.expand("%"), strategy = "dap"})<CR>', "[t]est [d]ebug Nearest")
    -- map_normal_mode("<leader>td", ':lua require("neotest").run.run({ strategy = "dap" })<CR>', "[t]est [d]ebug Nearest")
    -- map_normal_mode("<leader>tg", function()
    --   -- FIXME: https://github.com/nvim-neotest/neotest-go/issues/12
    --   -- Depends on "leoluz/nvim-dap-go"
    --   require("dap-go").debug_test()
    -- end, "[d]ebug [g]o (nearest test)")
  }
end

function M.setup_dap_ui_keymaps()
  -- keymaps: https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L508
  return {
    {
      "<leader>du",
      function()
        require("dapui").toggle({})
      end,
      desc = "DAP UI",
    },

    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      desc = "DAP Eval",
    },
  }
end

function M.setup_dap_keymaps()
  return {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "toggle [d]ebug [b]reakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "[d]ebug [B]reakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "[d]ebug [c]ontinue (start here)",
    },
    {
      "<leader>dC",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "[d]ebug [C]ursor",
    },
    {
      "<leader>dg",
      function()
        require("dap").goto_()
      end,
      desc = "[d]ebug [g]o to line",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "[d]ebug step [o]ver",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "[d]ebug step [O]ut",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "[d]ebug [i]nto",
    },
    {
      "<leader>dj",
      function()
        require("dap").down()
      end,
      desc = "[d]ebug [j]ump down",
    },
    {
      "<leader>dk",
      function()
        require("dap").up()
      end,
      desc = "[d]ebug [k]ump up",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "[d]ebug [l]ast",
    },
    {
      "<leader>dp",
      function()
        require("dap").pause()
      end,
      desc = "[d]ebug [p]ause",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "[d]ebug [r]epl",
    },
    {
      "<leader>dR",
      function()
        require("dap").clear_breakpoints()
      end,
      desc = "[d]ebug [R]emove breakpoints",
    },
    {
      "<leader>ds",
      function()
        require("dap").session()
      end,
      desc = "[d]ebug [s]ession",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "[d]ebug [t]erminate",
    },
    {
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "[d]ebug [w]idgets",
    },
  }
end

return M
