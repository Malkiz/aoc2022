local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day12/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local offset = string.byte('a')
local grid = {}
local rowIdx = 1
local S = nil
local E = nil

for line in fileContent:gmatch("(.-)\n") do
  local row = {}
  for i = 1, #line do
    local c = line:sub(i, i)
    if c == 'S' then
      table.insert(row, 1)
      S = { rowIdx, i }
    elseif c == 'E' then
      table.insert(row, 26)
      E = { rowIdx, i }
    else
      table.insert(row, string.byte(c) - offset + 1)
    end
  end
  table.insert(grid, row)
  rowIdx = rowIdx + 1
end

local visited = {}
local directions = {
  { 0,  1 },
  { 1,  0 },
  { 0,  -1 },
  { -1, 0 },
}

for i = 1, #grid do
  local row = {}
  for j = 1, #grid[i] do
    table.insert(row, -1)
  end
  table.insert(visited, row)
end

local function isPosition(a, b)
  return a[1] == b[1] and a[2] == b[2]
end

local function canMove(from, to)
  if to[1] < 1 or to[1] > #grid or to[2] < 1 or to[2] > #grid[to[1]] then
    return false
  end
  return grid[to[1]][to[2]] - grid[from[1]][from[2]] <= 1
end

local function findPath(step, position)
  for i = 1, #directions do
    local direction = directions[i]
    local nextPosition = { position[1] + direction[1], position[2] + direction[2] }
    if canMove(position, nextPosition) then
      local vis = visited[nextPosition[1]][nextPosition[2]]
      if vis == -1 or vis > step + 1 then
        visited[nextPosition[1]][nextPosition[2]] = step + 1
        if not isPosition(nextPosition, E) then
          findPath(step + 1, nextPosition)
        end
      end
    end
  end
end

findPath(0, S)

print(visited[E[1]][E[2]])
