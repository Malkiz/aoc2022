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
