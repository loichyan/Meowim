---@type MeoSpec
return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  config = function()
    local by_ft = {}
    for ft, linters in pairs({
      -- Add your preferred linters here
      -- markdown = { "vale" },
    }) do
      by_ft[ft] = linters
    end

    require("lint").linters_by_ft = by_ft
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      desc = "Lint current buffer",
      callback = require("snacks").util.debounce(
        function() require("lint").try_lint() end,
        { ms = 150 }
      ),
    })
  end,
}
