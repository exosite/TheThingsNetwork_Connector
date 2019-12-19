-- This module cache value to local map
-- To be usefull this function requires the solution to enable the HotVM setting

local cache = {}
function cache.get(key, getter, timeout)
  local now = os.time();
  if not cache[key] or cache[key].ts < now + (timeout or 30) then
    local value;
    if getter then
      value = getter(key)
    else
      value = Keystore.get({ key = key })
    end
    if value == nil or value.error then
      return nil
    end
    cache[key] = {
      ts = now,
      value = value
    }
  end
  return cache[key].value
end

function cache.set(key, value, setter)
  if cache[key] == value then
    return
  end

  local result
  if setter then
    result = setter(key, value)
  else
    result = Keystore.set({ key =  key, value = value})
  end
  if result and result.error then
    return nil
  end
  cache[key] = {
    ts = os.time(),
    value = value
  }
  return value
end

return cache
