
local murano2cloud = require("c2c.murano2cloud")

-- This event listen to the changes made on the Service configuration to react to user setting change
if service.service == murano2cloud.alias and (service.action == "added" or service.action == "updated") then
  local result = Config.getParameters({service = service.service})
  if (result.parameters.token and not result.parameter.callback_token) then
    -- If enabled by the remote API create a callback automatically
    local callback_token = CloudServiceName.createCallback()
    -- If the callback credentials is different from the API's save it.
    if callback_token then
      Config.setParameters({service = service.service, parameters = { callback_token = callback_token }})
      result.parameter.callback_token = callback_token
    end

    -- New credentials: sync devices
    murano2cloud.syncAll()
  end

  if (result.parameters.callback_token) then
    -- User changed the token save it.
    require("c2c.authentication").setToken(service.parameters.callback_token)
  end
end
