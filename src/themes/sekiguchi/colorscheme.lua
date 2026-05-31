return {
  {
    dir = vim.env.APPEARANCE_DIR .. "/src/themes/sekiguchi/sekiguchi.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("sekiguchi")
    end,
  },
}
