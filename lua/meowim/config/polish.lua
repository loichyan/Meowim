-- Other configurations thay may slow down the startup.

-- For to use JSONC instead of bare JSON.
vim.filetype.add({ extension = { json = "jsonc" } })

-- Other configurations
-- TODO: enable virtual lines when diagnostics on the screen are not too many
vim.diagnostic.config({ virtual_text = true })
