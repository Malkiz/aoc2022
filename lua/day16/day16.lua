local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day16/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for line in fileContent:gmatch("(.-)\n") do
  table.insert(lines, line)
end

local valves = {}

for i, line in pairs(lines) do
  local name, flowRate, tunnels = line:match("Valve (..) has flow rate=(%d+); tunnel[s]? lead[s]? to valve[s]? (.*)")
  local tunnelNames = {}
  for tunnelName in (tunnels .. ", "):gmatch("(..), ") do
    table.insert(tunnelNames, tunnelName)
  end
  local valve = { flowRate = tonumber(flowRate), tunnels = tunnelNames }
  valves[name] = valve
end

local start = "AA"
local minutes = 30

local function cloneTable(t)
  local result = {}
  for k, v in pairs(t) do
    result[k] = v
  end
  return result
end

local function potential(ppm, total, valvesOpen, minutesLeft)
  local notOpen = {}
  for k, v in pairs(valves) do
    if not valvesOpen[k] then
      table.insert(notOpen, v.flowRate)
    end
  end

  table.sort(notOpen, function(a, b) return a > b end)

  local res = total
  for i = 1, minutesLeft do
    res = res + ppm
    if i % 2 ~= 0 then
      local j = math.floor(i / 2) + 1
      if j <= #notOpen then
        ppm = ppm + notOpen[j]
      end
    end
  end

  return res
end

local iterations = 0

local function maxPerssure(ppm, total, valvesOpen, position, minutesLeft, best, visited)
  iterations = iterations + 1
  if minutesLeft == 0 then
    -- print(total)
    return total
  end

  local p = potential(ppm, total, valvesOpen, minutesLeft)
  if best > p then
    -- print('pruned')
    return p
  end

  if visited[position] then
    -- print('loop')
    return total
  end

  local valve = valves[position]

  local newTotal = total + ppm
  best = math.max(best, newTotal)

  local res1 = 0
  if not valvesOpen[position] then
    local newValvesOpen = cloneTable(valvesOpen)
    newValvesOpen[position] = true
    res1 = maxPerssure(ppm + valve.flowRate, newTotal, newValvesOpen, position, minutesLeft - 1, best, {})
  end

  best = math.max(best, res1)

  local res2 = 0
  local newVisited = cloneTable(visited)
  newVisited[position] = true
  for i, tunnel in pairs(valve.tunnels) do
    local res = maxPerssure(ppm, newTotal, valvesOpen, tunnel, minutesLeft - 1, best, newVisited)
    res2 = math.max(res2, res)
    best = math.max(best, res2)
  end

  return math.max(res1, res2, best)
end

local result = maxPerssure(0, 0, {}, start, minutes, 0, {})
print(iterations)
print(result)
