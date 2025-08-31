---@type MeoSpec
local Spec = {
  "mini.completion",
  event = "LazyFile",
  dependencies = { "mini.snippets" },
}
local H = {}

Spec.config = function()
  local minicomp = require("mini.completion")

  local trigger_chars = { ".", ":", "(", "'", '"', "/" }
  Meow.autocmd("meowim.plugins.mini.completion", {
    {
      event = "LspAttach",
      desc = "Reduce unnecessary completion triggers",
      callback = function(args) H.filter_trigger_chars(args.data.client_id, trigger_chars) end,
    },
    {
      -- Must be executed before mini.completion's autocommmands
      event = "CompleteDonePre",
      desc = "Filter out unintended confirms",
      callback = function()
        -- Only use certain keys to confirm a completion.
        -- This resolves <https://github.com/nvim-mini/mini.nvim/issues/1938>.
        if not vim.g.meowim_complete_confirm then
          vim.v.completed_item = vim.empty_dict()
        else
          vim.g.meowim_complete_confirm = nil
        end
      end,
    },
  })

  local kind_priority = { Text = 1, Snippet = 99 }
  local process_opts = { kind_priority = kind_priority }
  local process_items = function(items, base)
    items = H.process_lsp_items(items)
    return MiniCompletion.default_process_items(items, base, process_opts)
  end

  vim.o.completeopt = "menuone,noselect,fuzzy"
  vim.o.infercase = false
  minicomp.setup({
    lsp_completion = {
      -- 'completefunc' conflicts with `Ctrl+U` in insert mode
      source_func = "omnifunc",
      process_items = process_items,
    },
    window = {
      info = { border = "solid" },
      signature = { border = "solid" },
    },
    -- stylua: ignore
    mappings = {
      force_twostep  = "<C-Space>",
      force_fallback = "<M-Space>",
      scroll_down    = "<C-f>",
      scroll_up      = "<C-b>",
    },
  })
  vim.lsp.config("*", { capabilities = minicomp.get_lsp_capabilities() })
end

---@param items lsp.CompletionItem[]
function H.process_lsp_items(items)
  local item_kind = vim.lsp.protocol.CompletionItemKind
  local textformat = vim.lsp.protocol.InsertTextFormat

  -- For each item, use only its first keyword part as the completion word if
  -- possible, which can increase the fuzzy-filtering accuracy and stop Nvim
  -- from inserting too many useless characters when it gets selected.
  for _, item in ipairs(items) do
    -- For snippet items, respect the abbr/word/filterText anyway, since they
    -- are configured intentionally.
    if item.kind ~= item_kind.Snippet then
      local abbr = item.label -- word shown in popupmenu
      local word = abbr:match("^[-_.%w]+") or abbr -- word used to match
      local textedit = (item.textEdit or {}).newText
      local inserttext = textedit or item.insertText or abbr -- word to be inserted

      item.filterText = word
      item.sortText = word

      if word == inserttext then
        -- If the completion word matches the text to be inserted, do not make it
        -- a potential snippet, since some LSPs report all items as snippets.
        item.insertTextFormat = textformat.PlainText
      else
        -- Otherwise, ensure the new item can be recognized as a snippet by
        -- mini.completion. The presence of at least one tabstop is important,
        -- which resolves <https://github.com/nvim-mini/mini.nvim/issues/1944>.
        item.insertTextFormat = textformat.Snippet
        local has_tabstop = inserttext:find("[^\\]%${?%w") or inserttext:find("^%${?%w")
        if has_tabstop then
        elseif textedit then
          item.textEdit.newText = textedit .. "$0"
        else
          item.insertText = inserttext .. "$0"
        end
      end
    end
  end

  return items
end

function H.filter_trigger_chars(client_id, trigger_chars)
  local client = vim.lsp.get_client_by_id(client_id)
  if not client or not client:supports_method("textDocument/completion") then return end
  local compProvider = assert(client.server_capabilities.completionProvider)
  compProvider.triggerCharacters = vim.tbl_filter(
    function(c) return vim.tbl_contains(trigger_chars, c) end,
    compProvider.triggerCharacters or {}
  )
end

return Spec
