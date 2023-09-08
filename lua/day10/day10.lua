local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day10/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for w in fileContent:gmatch("(.-)\n") do
  table.insert(lines, w)
end

local x = 1
local cycle = 0
local cycles = { 20, 60, 100, 140, 180, 220 }
local currOp = nil
local lineIndex = 1

local function getOp()
  if currOp == nil then
    local line = lines[lineIndex]
    local op, num
    if (line == nil) then
      return
    end
    if line:sub(1, 1) == 'n' then
      op = 'noop'
    else
      local _, n = line:match("(.+)%s(.+)")
      op = 'addx'
      num = tonumber(n)
    end
    lineIndex = lineIndex + 1
    currOp = { op = op, num = num, opCycle = 0 }
  end
  currOp.opCycle = currOp.opCycle + 1
end

local function isSpecialCycle()
  for i = 1, #cycles do
    if cycles[i] == cycle then
      return true
    end
  end
  return false
end

local function doOp()
  if currOp.op == "noop" then
    currOp = nil
  else
    if currOp.opCycle == 2 then
      x = x + currOp.num
      currOp = nil
    end
  end
end

local sum = 0

local function doCycle()
  getOp()
  if currOp == nil then
    return false
  end
  cycle = cycle + 1
  if isSpecialCycle() then
    sum = sum + (x * cycle)
  end
  doOp()
  return true
end

while doCycle() do
end

print(sum)
