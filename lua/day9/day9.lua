local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day9/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for w in fileContent:gmatch("(.-)\n") do
  table.insert(lines, w)
end

local rope = {}
for i = 1, 10 do
  rope[i] = { 0, 0 }
end

local function moveH(dir)
  local H = rope[1]
  if dir == "R" then
    H[1] = H[1] + 1
  elseif dir == "L" then
    H[1] = H[1] - 1
  elseif dir == "U" then
    H[2] = H[2] + 1
  elseif dir == "D" then
    H[2] = H[2] - 1
  end
end

local pastT = {}
local function saveT()
  local T = rope[#rope]
  local key = T[1] .. "," .. T[2]
  -- print(key)
  pastT[key] = true
end

local function moveT(knot)
  local H = rope[knot]
  local T = rope[knot + 1]
  local diffX = H[1] - T[1]
  local diffY = H[2] - T[2]
  if math.abs(diffX) >= 2 or math.abs(diffY) >= 2 then
    if diffX ~= 0 then
      local stepX = diffX / math.abs(diffX)
      T[1] = T[1] + stepX
    end
    if diffY ~= 0 then
      local stepY = diffY / math.abs(diffY)
      T[2] = T[2] + stepY
    end
  end
end

saveT()
for i = 1, #lines do
  local dir, num = lines[i]:match("(.+)%s(%d+)")
  for j = 1, num do
    moveH(dir)
    for k = 1, #rope - 1 do
      moveT(k)
    end
    saveT()
  end
end

local count = 0
for k, v in pairs(pastT) do
  count = count + 1
end

print(count)
