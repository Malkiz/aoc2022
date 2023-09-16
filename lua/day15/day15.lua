local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day15/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for line in fileContent:gmatch("(.-)\n") do
  table.insert(lines, line)
end

local function manhattanDistance(a, b)
  return math.abs(a[1] - b[1]) + math.abs(a[2] - b[2])
end

-- print(lines[1])
local data = {}

for i, line in pairs(lines) do
  local x1, y1, x2, y2 = line:match(".*x=(.-), y=(.-):.*x=(.-), y=(.*)")
  local d = { sensor = { tonumber(x1), tonumber(y1) }, beacon = { tonumber(x2), tonumber(y2) } }
  d.distance = manhattanDistance(d.sensor, d.beacon)
  table.insert(data, d)
end

local minX, maxX, minY, maxY = data[1].sensor[1], data[1].sensor[1], data[1].sensor[2], data[1].sensor[2]

for i, d in pairs(data) do
  if d.sensor[1] < minX then minX = d.sensor[1] end
  if d.sensor[1] > maxX then maxX = d.sensor[1] end
  if d.sensor[2] < minY then minY = d.sensor[2] end
  if d.sensor[2] > maxY then maxY = d.sensor[2] end
  if d.beacon[1] < minX then minX = d.beacon[1] end
  if d.beacon[1] > maxX then maxX = d.beacon[1] end
  if d.beacon[2] < minY then minY = d.beacon[2] end
  if d.beacon[2] > maxY then maxY = d.beacon[2] end
end

local offset = 1000000
minX = minX - offset
maxX = maxX + offset
minY = minY - offset
maxY = maxY + offset

-- print(minX, maxX, minY, maxY)

local y = 2000000
local countNo = 0
-- local str = ''

for x = minX, maxX do
  local closer = false
  local beacon = false
  local sensor = false
  for i, d in pairs(data) do
    if d.sensor[1] == x and d.sensor[2] == y then
      sensor = true
      break
    end
    if d.beacon[1] == x and d.beacon[2] == y then
      beacon = true
      break
    end
    if d.distance >= manhattanDistance({ x, y }, d.sensor) then
      closer = true
      break
    end
  end
  if sensor then
    -- str = str .. 'S'
  elseif beacon then
    -- str = str .. 'B'
  elseif closer then
    -- str = str .. '#'
    countNo = countNo + 1
  else
    -- str = str .. '.'
  end
end

-- print(str)
print(countNo)
