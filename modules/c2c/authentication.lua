local authentication = {}
-- This module authenticates the 3rd party cloud callback requests
-- To be updated depending on the security requirements

local mcrypto = require("staging.mcrypto")

local cloudServiceName = require("c2c.murano2cloud").alias
local cache = require("c2c.vmcache")

local function getToken()
  -- This function retrieve the token from the 3rd party service parameters
  local config = Config.getParameters({service = cloudServiceName})
  -- In the case of a callback only setup, you can use ENV instead with:
  -- return os.getenv("callback_token")
  -- See ./murano.yaml configuration file for how to define ENV parameters
  return config and config.parameters and config.parameters.callback_token
end

local function getDomain()
  local config = Config.getParameters({service = "webservice"})
  return config and config.parameters and config.parameters.domain
end

local function getLastWord(str)
  if not str then return end
  local v
  for i in str:gmatch("%S+") do
    v = i
  end
  return v
end

function authentication.getPeer(request)
  -- Enable this line to validate incoming callback token
  local token = cache.get("callback_token", getToken)
  if not token or #token == 0 then return "ok" end -- no token set
  if (request.parameters.token or getLastWord(request.headers.authorization)) == token then
    return "ok"
  end
end

function authentication.setToken(callback_token)
  -- If needed generate a token for connecting the 3rd party service to this solution
  callback_token = callback_token or mcrypto.b64url_encode(mcrypto.rand_bytes(20))

  -- Get Webservice domain parameters from configuration
  local callback_url = 'https://' .. cache.get("domain", getDomain) .. '/c2c/callback?token=' .. callback_token

  Config.setParameters({service = cloudServiceName, parameters = {
    -- to enable changing token from Murano UI
    callback_token = callback_token,
    -- so use can manually copy/past the callback url from Murano UI
    callback_url = callback_url
  }})
  return token
end

return authentication
