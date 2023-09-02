local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day7/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for w in fileContent:gmatch("(.-)\n") do
  table.insert(lines, w)
end

local lineIdx = 1
local dirs = {}
local path = {}

local function isCmd()
  if lineIdx > #lines then
    return false
  end
  local line = lines[lineIdx]
  return line:sub(1, 1) == '$'
end

local function runLs()
  local dirName = table.concat(path, "/")
  -- print(dirName)
  dirs[dirName] = {}
  lineIdx = lineIdx + 1
  while isCmd() == false and lineIdx <= #lines do
    local line = lines[lineIdx]
    -- print(line)
    local a, b = line:match("(.+)%s+(.+)")
    if a == "dir" then
      local dir = table.concat(path, "/") .. "/" .. b
      table.insert(dirs[dirName], a .. " " .. dir)
    else
      table.insert(dirs[dirName], line)
    end
    lineIdx = lineIdx + 1
  end
  lineIdx = lineIdx - 1
end

local function runCmd()
  local line = lines[lineIdx]
  local _, cmd, arg = line:match("(%$) (%w+)%s*(.*)")
  if cmd == "cd" then
    if arg == "/" then
      path = { "/" }
    elseif arg == ".." then
      table.remove(path)
    else
      table.insert(path, arg)
    end
  elseif cmd == "ls" then
    runLs()
  end
end

while lineIdx <= #lines do
  if isCmd() then
    -- print(lines[lineIdx])
    runCmd()
  end
  lineIdx = lineIdx + 1
end

local function dirSize(dirName)
  local size = 0
  local dir = dirs[dirName]
  for i = 1, #dir do
    local line = dir[i]
    local a, b = line:match("(.+)%s+(.+)")
    if a == "dir" then
      size = size + dirSize(b)
    else
      size = size + tonumber(a)
    end
  end
  return size
end

local sum = 0
for k, v in pairs(dirs) do
  local size = dirSize(k)
  if (size <= 100000) then
    sum = sum + size
  end
end

print(sum)
