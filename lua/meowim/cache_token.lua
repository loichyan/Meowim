if vim.env["MEO_DISABLE_CACHE"] then return false end

local config_dir = vim.fn.stdpath("config")
local token_path = config_dir .. "/cache_token"
local token_file = io.open(token_path, "r")
local token = token_file and token_file:read("*a") or nil

-- Refresh token in the background
vim.schedule(function()
  vim.system({ "git", "-C", config_dir, "rev-parse", "HEAD" }, nil, function(out)
    local new_token = vim.trim(out.stdout or "")
    if new_token == token then return end
    io.open(token_path, "w"):write(new_token)
    if token ~= nil then
      Meow.notify("WARN", "Meowim has been updated. Please restart to apply the changes.")
    end
  end)
end)

return token or tostring(math.random(0, 0xffffffff))
