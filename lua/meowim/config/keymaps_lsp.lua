---------------------------------
---------- LSP KEYMAPS ----------
---------------------------------

local H = {}

---@param picker string
---@param opts? table
function H.pick(picker, opts) require("mini.pick").registry[picker](opts) end

---Lists only items of current buffer.
---@param opts vim.lsp.LocationOpts.OnList
function H.lsp_list_buf(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    opts.items = vim.tbl_filter(
        function(v) return v.bufnr == bufnr or v.filename == bufname end,
        opts.items
    )
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.fn.setqflist({}, " ", opts)
    vim.schedule(function() vim.cmd("copen") end)
end

---@param scope "current"|"all"
function H.lsp_implementation(scope)
    vim.lsp.buf.implementation({
        on_list = scope == "current" and H.lsp_list_buf or nil,
    })
end

---@param scope "current"|"all"
function H.lsp_references(scope)
    vim.lsp.buf.references({ includeDeclaration = false }, {
        on_list = scope == "current" and H.lsp_list_buf or nil,
    })
end

-- stylua: ignore
local keymaps = {
    { "K",  function() vim.lsp.buf.hover() end,           has = "textDocument/hover",          desc = "Show documentation"   },
    -- TODO: filter out useless definitions
    { "gd", function() vim.lsp.buf.definition() end,      has = "textDocument/definition",     desc = "Goto definition"      },
    { "gD", function() vim.lsp.buf.type_definition() end, has = "textDocument/typeDefinition", desc = "Goto type definition" },

    { "]r", function() require("snacks.words").jump( vim.v.count1, true) end, desc = "Reference forward"  },
    { "[r", function() require("snacks.words").jump(-vim.v.count1, true) end, desc = "Reference backward" },

    { "<Leader>la", function() vim.lsp.buf.code_action() end,   desc = "List code actions", mode = { "n", "x" } },
    { "<Leader>lf", function() require("conform").format() end, desc = "Format",            mode = { "n", "x" } },

    { "<Leader>ln", function() vim.lsp.buf.rename() end,                          desc = "Rename" },
    { "<Leader>li", function() H.lsp_implementation("current") end,               desc = "List buffer implementations"    },
    { "<Leader>lI", function() H.lsp_implementation("all") end,                   desc = "List workspace implementations" },
    { "<Leader>lr", function() H.lsp_references("current") end,                   desc = "List buffer references"    },
    { "<Leader>lR", function() H.lsp_references("all") end,                       desc = "List workspace references" },
    { "<Leader>ls", function() H.pick("lsp", { scope = "document_symbol" }) end,  desc = "Pick buffer symbols"    },
    { "<Leader>lS", function() H.pick("lsp", { scope = "workspace_symbol" }) end, desc = "Pick workspace symbols" },
}

return {
    ---@param bufnr integer
    ---@param client vim.lsp.Client
    setup = function(bufnr, client)
        local specs = {}
        for _, spec in ipairs(keymaps) do
            -- Setup certain keymaps only if the client supports it
            if not spec.has or client:supports_method(spec.has, bufnr) then
                spec = vim.tbl_extend("force", spec, { buffer = bufnr })
                spec.has = nil
                table.insert(specs, spec)
            end
        end
        Meow.keyset(bufnr, specs)
    end,
}
