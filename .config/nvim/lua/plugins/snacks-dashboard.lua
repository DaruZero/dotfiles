return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
  ·▄▄▄▄   ▄▄▄· ▄▄▄  ▄• ▄▌ ▌ ▐·▪▀ • ▌ ▄ ·. 
  ██▪ ██ ▐█ ▀█ ▀▄ █·█▪██▌▪█·█▌██ ·██ ▐███▪
  ▐█· ▐█▌▄█▀▀█ ▐▀▀▄ █▌▐█▌▐█▐█•▐█·▐█ ▌▐▌▐█·
  ██. ██ ▐█ ▪▐▌▐█•█▌▐█▄█▌ ███ ▐█▌██ ██▌▐█▌
  ▀▀▀▀▀•  ▀  ▀ .▀  ▀ ▀▀▀ . ▀  ▀▀▌▀▀  █▪▀▀▀]],
      },
      sections = {
        { section = "header", padding = 2 },
        {
          pane = 2,
          section = "terminal",
          cmd = "chafa ~/.config/nvim/static/wall.jpg --format symbols --symbols vhalf --size 60x12 --stretch; sleep .1",
          height = 12,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
