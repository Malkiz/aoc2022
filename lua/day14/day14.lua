local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day14/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for line in fileContent:gmatch("(.-)\n") do
  table.insert(lines, line)
end

local rocks = {}
for i, line in pairs(lines) do
  local rock = {}
  for coord in (line .. " -> "):gmatch("(.-) -> ") do
    local x, y = coord:match("(%d+),(%d+)")
    table.insert(rock, { tonumber(x), tonumber(y) })
  end
  table.insert(rocks, rock)
end

local source = { 500, 0 }

local minX, maxX, minY, maxY = source[1], source[1], source[2], source[2]
for i, rock in pairs(rocks) do
  for j, coord in pairs(rock) do
    if coord[1] < minX then minX = coord[1] end
    if coord[1] > maxX then maxX = coord[1] end
    if coord[2] < minY then minY = coord[2] end
    if coord[2] > maxY then maxY = coord[2] end
  end
end

-- print(minX, maxX, minY, maxY)

local infinity = 10000
minX = minX - infinity
maxX = maxX + infinity
maxY = maxY + 2
local grid = {}

for y = minY, maxY do
  grid[y] = {}
  for x = minX, maxX do
    grid[y][x] = '.'
  end
end

for x = minX, maxX do
  grid[maxY][x] = '#'
end

for i, rock in pairs(rocks) do
  for j = 1, #rock - 1 do
    local coord1 = rock[j]
    local coord2 = rock[j + 1]
    if coord1[1] == coord2[1] then
      local smallY = math.min(coord1[2], coord2[2])
      local bigY = math.max(coord1[2], coord2[2])
      for y = smallY, bigY do
        grid[y][coord1[1]] = '#'
      end
    else
      local smallX = math.min(coord1[1], coord2[1])
      local bigX = math.max(coord1[1], coord2[1])
      for x = smallX, bigX do
        grid[coord1[2]][x] = '#'
      end
    end
  end
end

grid[source[2]][source[1]] = '+'

local function printGrid()
  for y = minY, maxY do
    local line = ''
    for x = minX, maxX do
      line = line .. grid[y][x]
    end
    print(line)
  end
end

-- printGrid()

local function isInGrid(sand)
  return sand[1] >= minX and sand[1] <= maxX and sand[2] >= minY and sand[2] <= maxY
end

local function moveSand(sand)
  local down = { sand[1], sand[2] + 1 }
  if not isInGrid(down) or grid[down[2]][down[1]] == '.' then
    return down
  end
  local downleft = { sand[1] - 1, sand[2] + 1 }
  if not isInGrid(downleft) or grid[downleft[2]][downleft[1]] == '.' then
    return downleft
  end
  local downright = { sand[1] + 1, sand[2] + 1 }
  if not isInGrid(downright) or grid[downright[2]][downright[1]] == '.' then
    return downright
  end
  return sand
end

local function addSand()
  local sand = { source[1], source[2] }
  local newSand
  while isInGrid(sand) do
    newSand = moveSand(sand)
    if newSand[1] == sand[1] and newSand[2] == sand[2] then
      break
    end
    sand = newSand
  end
  if isInGrid(newSand) and grid[newSand[2]][newSand[1]] ~= '+' then
    grid[newSand[2]][newSand[1]] = 'o'
    return true
  else
    return false
  end
end

local count = 0
while addSand() do
  count = count + 1
  -- printGrid()
  -- print(count)
end
--printGrid()
print(count + 1)
