local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day3/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local function charToNumber(char)
  local lowercaseA = string.byte("a")
  local uppercaseA = string.byte("A")
  local charCode = string.byte(char)

  if charCode >= lowercaseA and charCode <= lowercaseA + 25 then
    return charCode - lowercaseA + 1
  else
    return charCode - uppercaseA + 27
  end
end

local sum = 0
for w in fileContent:gmatch("(.-)\n") do
  local len = #w
  local a = w:sub(1, len / 2)
  local b = w:sub(len / 2 + 1, len)
  local aDict = {}
  for i = 1, #a do
    local c = a:sub(i, i)
    aDict[c] = true
  end
  local sameChar = ""
  for i = 1, #b do
    local c = b:sub(i, i)
    if aDict[c] then
      sameChar = c
      break
    end
  end
  local codePoint = charToNumber(sameChar)
  sum = sum + codePoint
end

print(sum)

local lines = {}
for line in fileContent:gmatch("(.-)\n") do
  table.insert(lines, line)
end

sum = 0
for i = 1, #lines, 3 do
  local charDict1 = {}
  local charDict2 = {}
  local line1 = lines[i]
  local line2 = lines[i + 1]
  local line3 = lines[i + 2]

  for j = 1, #line1 do
    local c = line1:sub(j, j)
    charDict1[c] = true
  end

  for j = 1, #line2 do
    local c = line2:sub(j, j)
    charDict2[c] = true
  end

  local sameChar = ""
  for j = 1, #line3 do
    local c = line3:sub(j, j)
    if charDict1[c] and charDict2[c] then
      sameChar = c
      break
    end
  end

  local codePoint = charToNumber(sameChar)
  sum = sum + codePoint
end

print(sum)
