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

-- local y = 10
-- local countNo = 0
-- local str = ''

local signalMin = 0
local signalMax = 4000000

local function findEmpty()
  for y = signalMin, signalMax do
    -- print(y)
    local x = signalMin
    while x <= signalMax do
      -- print(y, x)
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
          local diffY = math.abs(y - d.sensor[2])
          local remainder = d.distance - diffY
          local diffX = x - d.sensor[1]
          local moveX = remainder - diffX
          if moveX > 0 then
            x = x + moveX
          end
          break
        end
      end
      if sensor then
        -- str = str .. 'S'
      elseif beacon then
        -- str = str .. 'B'
      elseif closer then
        -- str = str .. '#'
        -- countNo = countNo + 1
      else
        -- str = str .. '.'
        return { x, y }
      end
      x = x + 1
    end
  end
end

local empty = findEmpty()

-- print(str)
print(empty[1], empty[2])

local freq = empty[1] * 4000000 + empty[2]
print(freq)
