-- This file enable device data transformation for the template user
--
-- This file is in the 'vendor' safeNamespace and changes will persists upon template updates

local transform = {}
local bit = require("vendor.bit")

function transform.data_in(cloud_data)
  -- Transform data from the 3rd party service to Murano

  if not cloud_data.payload_raw then
    log.warn("Cannot find data in callback payload..", to_json(cloud_data))
    return
  end

  local payload = string.tohex(dec(cloud_data.payload_raw))

  -- example payload 00 00 00 00 01 1B 09 B9 38
  --                 -ACI1 -ACI2 -AVI1 -AVI2 COMBO
  -- COMBO is: <b7..0> <RO1.RO2.DI3.DI2.DI1.DO3.DO2.DO1>

  local data_in = {}
  data_in["001"] = tonumber(string.sub(payload,1,4),16) 		-- ACI1
  data_in["002"] = tonumber(string.sub(payload,5,8),16) 		-- ACI2
  data_in["003"] = tonumber(string.sub(payload,9,12),16)		-- AVI1
  data_in["004"] = tonumber(string.sub(payload,13,16),16) 	-- AVI2
  local DIO_data = tonumber(string.sub(payload,17,18),16)
  data_in["005"] = check(bit.band(0x80,DIO_data))           -- ROI1
  data_in["006"] = check(bit.band(0x40,DIO_data))           -- ROI2
  data_in["007"] = check(bit.band(0x20,DIO_data))           -- DI3
  data_in["008"] = check(bit.band(0x10,DIO_data))           -- DI2
  data_in["009"] = check(bit.band(0x08,DIO_data))           -- DI1
  data_in["010"] = check(bit.band(0x04,DIO_data))           -- DO3
  data_in["011"] = check(bit.band(0x02,DIO_data))           -- DO2
  data_in["012"] = check(bit.band(0x01,DIO_data))           -- DO1

  data_in = to_json(data_in)

  return {
    -- Required device identity
    identity = cloud_data.hardware_serial,
    -- Device data, here following ExoSense data model
    data_in = data_in
  }
end

function transform.data_out(murano_data)
  -- Transform data from Murano to the 3rd party service
  return murano_data
end

-----------
-----------

function check(i)
	if i == 0 then
		return 0
	else
		return 1
	end
end


function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end


-- Start taken from https://stackoverflow.com/a/35303321
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
 
-- decoding
function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end
-- end of copy

return transform
