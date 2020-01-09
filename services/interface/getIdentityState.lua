local identityState = Device2.getIdentityState(operation)
if identityState.error then return identityState end

local configIO = require("vendor.configIO")
local cio = identityState.config_io
if not cio or not cio.set or cio.set:sub(1, 2) == "<<" and configIO then
  identityState.config_io = {
    timestamp = require("c2c.utils").getTimestamp(configIO.timestamp),
    set = configIO.config_io,
    reported = configIO.config_io
  }
end

return identityState
