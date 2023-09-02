local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day5/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local stacksLines = {}
local movesLines = {}
local linesDict = stacksLines
for w in fileContent:gmatch("(.-)\n") do
  if w == "" then
    linesDict = movesLines
    goto continue
  end
  table.insert(linesDict, w)
  ::continue::
end

local stacks = {}
local stackNums = stacksLines[#stacksLines]:gmatch("(%d+) ")
for _ in stackNums do
  table.insert(stacks, {})
end

for i = #stacksLines - 1, 1, -1 do
  local line = stacksLines[i]
  -- print(line)
  for j = 1, #stacks do
    local index = 2 + (j - 1) * 4
    if index > #line then
      break
    end
    local box = line:sub(index, index)
    if box == " " then
      goto continue
    end
    local stack = stacks[j]
    table.insert(stack, box)
    -- print(box, j)
    ::continue::
  end
end

for i = 1, #movesLines do
  local line = movesLines[i]
  local num, from, to = line:match("(%d+).*(%d+).*(%d+)")
  -- print(num, from, to)
  local fromStack = stacks[tonumber(from)]
  local toStack = stacks[tonumber(to)]
  for _ = 1, tonumber(num) do
    local box = table.remove(fromStack)
    table.insert(toStack, box)
  end
end

local topBoxes = ""
for i = 1, #stacks do
  local stack = stacks[i]
  if #stack == 0 then
    goto continue
  end
  local topBox = stack[#stack]
  topBoxes = topBoxes .. topBox
  ::continue::
end

print(topBoxes)
