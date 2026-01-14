-- Minimal LeetGPU.nvim configuration
-- Just the essentials to get started

return {
    "Awallace3/LeetGPU.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lang = "cuda",
    },
}
