-- Create this as 'lua/bedrock_keys.lua' in your Neovim config directory
-- Basically a re-creation of this bash script
-- profile="${1:-default}"
-- credentials="$(aws configure export-credentials --profile "$profile")"
-- access_key=$(jq -r '.AccessKeyId' <<<"$credentials")
-- secret_key=$(jq -r '.SecretAccessKey' <<<"$credentials")
-- session_token=$(jq -r '.SessionToken' <<<"$credentials")
-- region=$(aws configure get region --profile "$profile")
-- export BEDROCK_KEYS="$access_key,$secret_key,$region,$session_token"

local M = {}

function M.set_bedrock_keys(profile)
  -- Default to 'default' profile if none specified
  profile = profile or "default"

  -- Get AWS credentials
  local credentials_handle = io.popen(
    string.format("aws configure export-credentials --profile %s", profile)
  )
  if credentials_handle == nil then
    vim.notify("error getting AWS credentials", vim.log.levels.ERROR)
    return
  end
  local credentials = credentials_handle:read("*a")
  credentials_handle:close()

  -- Parse JSON credentials using vim's json_decode
  local cred_data = vim.json.decode(credentials)

  -- Get region
  local region_handle =
    io.popen(string.format("aws configure get region --profile %s", profile))
  if region_handle == nil then
    vim.notify("cannot get AWS region", vim.log.levels.ERROR)
    return
  end
  local region = region_handle:read("*a"):gsub("%s+", "") -- Remove whitespace
  region_handle:close()

  -- Construct BEDROCK_KEYS string
  local bedrock_keys = table.concat({
    cred_data.AccessKeyId,
    cred_data.SecretAccessKey,
    region,
    cred_data.SessionToken,
  }, ",")

  -- Set environment variable in Neovim
  vim.env.BEDROCK_KEYS = bedrock_keys

  -- Notify user
  vim.notify(
    "BEDROCK_KEYS environment variable has been set",
    vim.log.levels.INFO
  )
end

return M
