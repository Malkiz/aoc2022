local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day1/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local currSum = 0
local elves = {}
for w in fileContent:gmatch("(.-)\n") do
  if w == "" then
    elves[#elves + 1] = currSum
    currSum = 0
  else
    currSum = currSum + w
  end
end

local max = elves[1]

for i = 2, #elves do
  if elves[i] > max then
    max = elves[i]
  end
end

print(max)
