-- This module defines a proxy on Device2 access to do the syncronisation with the remote cloud
local murano2cloud = require("c2c.murano2cloud")

-- Define in murano2cloud the function to overload matching the device2 operation signature
-- See http://docs.exosite.com/reference/services/device2

if murano2cloud then
  local d2 = { }
  setmetatable(d2, {
    __index = function(t, op)
      if murano2cloud[op] then
        return function(data)
          local cloudResult = murano2cloud[op](data)
          if not cloudResult or cloudResult.error then
            return cloudResult
          end
           -- pass the updated result to the device2 function
          return murano.services.device2[op](cloudResult)
        end
      end

      -- Other function get proxy to original behavior
      return murano.services.device2[op]
    end
  })
  _G["Device2"] = d2
end
-- There is no return function so this code get executed at each VM load without use of 'require'
