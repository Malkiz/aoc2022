local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day4/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local count = 0
local count2 = 0
for w in fileContent:gmatch("(.-)\n") do
  local a, b = w:match("(.+),(.+)")
  local aStart, aEnd = a:match("(.+)-(.+)")
  local bStart, bEnd = b:match("(.+)-(.+)")
  local aContainsB = tonumber(aStart) <= tonumber(bStart) and tonumber(aEnd) >= tonumber(bEnd)
  local bContainsA = tonumber(bStart) <= tonumber(aStart) and tonumber(bEnd) >= tonumber(aEnd)
  if aContainsB or bContainsA then
    count = count + 1
  end
  local overlapA = tonumber(aStart) <= tonumber(bStart) and tonumber(aEnd) >= tonumber(bStart)
  local overlapB = tonumber(bStart) <= tonumber(aStart) and tonumber(bEnd) >= tonumber(aStart)
  if overlapA or overlapB then
    count2 = count2 + 1
  end
end

print(count)
print(count2)
