local M = {}

--Wella's Power Word: Fortitude is removed.
--Your Lightning Shield is removed.
function M.parse(source)
  local result = {}
  local apostrophe = string.find(source, "'s")
  local buffStart = 6

  if apostrophe ~= nil then
    result.name = string.sub(source, 1, apostrophe - 1)
    buffStart = apostrophe + 3
  end

  local buffEnd = string.find(source, ' is removed.')
  result.buff = string.sub(source, buffStart, buffEnd - 1)
  return result
end

return M
