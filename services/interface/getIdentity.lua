local identity = Device2.getIdentity(operation)
if identity.error then return identity end

local configIO = require("vendor.configIO")
local cio = identityState.state.config_io
if not cio or not cio.set or cio.set:sub(1, 2) == "<<" and configIO then
  identity.state.config_io = {
    timestamp = configIO.timestamp,
    set = configIO.config_io,
    reported = configIO.config_io
  }
end

return identity
