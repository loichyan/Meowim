---@module "nvim-treesitter-textobjects"

---@type LazyPluginSpec
local Spec = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = "User AstroFile",
  dependencies = {
    {
      "nvim-treesitter",
      opts = {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]k"] = { query = "@block.outer", desc = "Next block start" },
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
            },
            goto_next_end = {
              ["]K"] = { query = "@block.outer", desc = "Next block end" },
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
            },
            goto_previous_start = {
              ["[k"] = { query = "@block.outer", desc = "Previous block start" },
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
            },
            goto_previous_end = {
              ["[K"] = { query = "@block.outer", desc = "Previous block end" },
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              [">K"] = { query = "@block.outer", desc = "Swap next block" },
              [">F"] = { query = "@function.outer", desc = "Swap next function" },
              [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
            },
            swap_previous = {
              ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
              ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
              ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
            },
          },
        },
      },
    },
  },
}

return Spec
