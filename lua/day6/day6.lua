local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day6/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local line
for w in fileContent:gmatch("(.-)\n") do
  line = w
  break
end

local function allCharsAreDifferet(str)
  local chars = {}
  for i = 1, #str do
    local char = str:sub(i, i)
    if chars[char] then
      return false
    end
    chars[char] = true
  end
  return true
end

local start
for i = 1, #line - 4 do
  local signal = line:sub(i, i + 3)
  if allCharsAreDifferet(signal) then
    start = i + 3
    break
  end
end

print(start)
