local M = {}
local H = require('meowim.config.keymaps_helpers')
local nx = { 'n', 'x' }

---@type (MeoKeySpec|{has?:string})[]
-- stylua: ignore
local lsp_keyaps = {
  { 'K',                   function() vim.lsp.buf.hover() end,     has = 'textDocument/hover',                     desc = 'Show documentation'                },
  { 'gd',                  function() H.lsp_definition() end,      has = 'textDocument/definition',                desc = 'Goto definition'                   },
  { 'gD',                  function() H.lsp_type_definition() end, has = 'textDocument/typeDefinition',            desc = 'Goto type definition'              },

  { ']r',                  function() require('snacks.words').jump( vim.v.count1, true) end,                       desc = 'Reference forward'                 },
  { '[r',                  function() require('snacks.words').jump(-vim.v.count1, true) end,                       desc = 'Reference backward'                },

  { '<Leader>la',          function() vim.lsp.buf.code_action() end, mode = nx,                                    desc = 'List code actions'                 },
  { '<Leader>lf',          function() require('conform').format() end, mode = nx,                                  desc = 'Format buffer'                     },
  { '<Leader>ln',          function() vim.lsp.buf.rename() end,                                                    desc = 'Rename cursor symbol'              },
  { '<Leader>li',          function() H.lsp_implementation('current') end,                                         desc = 'List buffer implementations'       },
  { '<Leader>lI',          function() H.lsp_implementation('all') end,                                             desc = 'List workspace implementations'    },
  { '<Leader>lr',          function() H.lsp_references('current') end,                                             desc = 'List buffer references'            },
  { '<Leader>lR',          function() H.lsp_references('all') end,                                                 desc = 'List workspace references'         },
  { '<Leader>ls',          function() H.pick('lsp', {scope='document_symbol'}) end,                                desc = 'Pick buffer symbols'               },
  { '<Leader>lS',          function() H.pick('lsp', {scope='workspace_symbol'}) end,                               desc = 'Pick workspace symbols'            },
}

M.setup = function(bufnr, client)
  local specs = {}
  for _, spec in ipairs(lsp_keyaps) do
    -- Setup conditional keymaps only if the client supports it
    if spec.has and client:supports_method(spec.has, bufnr) then
      spec = vim.deepcopy(spec)
      spec.has = nil
    end
    if not spec.has then table.insert(specs, spec) end
  end
  Meow.keymap(bufnr, specs)
end

return M
