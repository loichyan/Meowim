---@type MeoSpec
local Spec = { "mfussenegger/nvim-lint", event = "LazyFile" }

Spec.config = function()
  local lint = require("lint")
  lint.linters_by_ft = {
    -- Add your preferred linters here
    -- markdown = { "vale" },
  }

  Meow.autocmd("meowim.plugins.nvim-lint", {
    {
      event = { "BufReadPost", "BufWritePost", "InsertLeave" },
      desc = "Lint current buffer",
      -- stylua: ignore
      callback = require("snacks").util.debounce(function() require("lint").try_lint() end, { ms = 150 }),
    },
  })
end

return Spec
