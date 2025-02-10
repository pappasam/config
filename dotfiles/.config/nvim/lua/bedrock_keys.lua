-- Create this as 'lua/bedrock_keys.lua' in your Neovim config directory
-- Basically a re-creation of this bash script
-- profile="${1:-default}"
-- credentials="$(aws configure export-credentials --profile "$profile")"
-- access_key=$(jq -r '.AccessKeyId' <<<"$credentials")
-- secret_key=$(jq -r '.SecretAccessKey' <<<"$credentials")
-- session_token=$(jq -r '.SessionToken' <<<"$credentials")
-- region=$(aws configure get region --profile "$profile")
-- export BEDROCK_KEYS="$access_key,$secret_key,$region,$session_token"

-- Note: requires curl>=8.12, which resolves some bugs with aws

local M = {}

function M.set_bedrock_keys(profile)
  profile = profile or "default"
  local credentials = vim
    .system(
      { "aws", "configure", "export-credentials", "--profile", profile },
      { text = true }
    )
    :wait()
  if credentials.code ~= 0 then
    vim.notify(vim.trim(credentials.stderr), vim.log.levels.ERROR)
    return
  end
  local cred_data = vim.json.decode(credentials.stdout)
  local region = vim
    .system(
      { "aws", "configure", "get", "region", "--profile", profile },
      { text = true }
    )
    :wait()
  if region.code ~= 0 then
    vim.notify(vim.trim(region.stderr), vim.log.levels.ERROR)
    return
  end
  local region_text = vim.trim(region.stdout)
  local bedrock_keys = table.concat({
    cred_data.AccessKeyId,
    cred_data.SecretAccessKey,
    region_text,
    cred_data.SessionToken,
  }, ",")
  vim.env.BEDROCK_KEYS = bedrock_keys
  vim.notify(
    string.format(
      "BEDROCK_KEYS set for profile %s in region %s",
      profile,
      region_text
    ),
    vim.log.levels.INFO
  )
end

return M
