return {
    "dfenerski/pomo.nvim",
    version = "^0.7", -- Recommended, use latest release instead of latest commit
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
    dependencies = {
        -- Optional, but highly recommended if you want to use the "Default" timer
        "rcarriga/nvim-notify",
    },
    opts = {
        -- See below for full list of options 👇
    },
}
