local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day13/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for line in fileContent:gmatch("(.-)\n") do
  table.insert(lines, line)
end

local function listToString(list)
  local result = ''
  for i = 1, #list do
    if i > 1 then
      result = result .. ','
    end
    if type(list[i]) == "table" then
      result = result .. '[' .. listToString(list[i]) .. ']'
    else
      result = result .. list[i]
    end
  end
  return result
end

local function parse(line)
  -- print()
  -- print('parse', line)
  local stack = {}
  local top = nil
  local list = nil
  local i = 1
  while i <= #line do
    local char = line:sub(i, i)
    -- print(char)
    if char == '[' then
      if list ~= nil then
        table.insert(stack, list)
      end
      list = {}
      if top == nil then
        top = list
      end
      if #stack > 0 then
        table.insert(stack[#stack], list)
      end
      i = i + 1
    elseif char == ']' then
      list = table.remove(stack, #stack)
      i = i + 1
    elseif char == ',' then
      i = i + 1
    else
      local num = tonumber(line:match("%d+", i))
      table.insert(list, num)
      i = i + #tostring(num)
    end
  end
  local str = '[' .. listToString(top) .. ']'
  if (str ~= line) then
    print()
    print('Expected', line)
    print('Actual  ', str)
  end
  return top
end

local pairs = {}
for i = 1, #lines, 3 do
  local pair = { parse(lines[i]), parse(lines[i + 1]) }
  table.insert(pairs, pair)
end

local function compare(left, right)
  -- print(left, right)
  if type(left) == "number" and type(right) == "number" then
    if left < right then
      return 1
    elseif left > right then
      return -1
    else
      return 0
    end
  elseif type(left) == "table" and type(right) == "table" then
    -- print('sizes', #left, #right)
    for i = 1, #left do
      if i > #right then
        return -1
      end
      local result = compare(left[i], right[i])
      if result ~= 0 then
        return result
      end
    end
    if #left < #right then
      return 1
    end
    return 0
  else
    if type(left) == "number" then
      return compare({ left }, right)
    else
      return compare(left, { right })
    end
  end
end

local sum = 0

for i = 1, #pairs do
  -- print('Compare', i)
  local result = compare(pairs[i][1], pairs[i][2])
  -- print('Result', i, result)
  -- print()
  if result == 1 then
    sum = sum + i
  end
end

print(sum)

local packets = {}
for i = 1, #pairs do
  table.insert(packets, pairs[i][1])
  table.insert(packets, pairs[i][2])
end

local divider1 = { { 2 } }
local divider2 = { { 6 } }

table.insert(packets, divider1)
table.insert(packets, divider2)

table.sort(packets, function(left, right)
  return compare(left, right) == 1
end)

local divider1Index = 0
local divider2Index = 0
for index, packet in ipairs(packets) do
  if packet == divider1 then
    divider1Index = index
  elseif packet == divider2 then
    divider2Index = index
  end
end

local key = divider1Index * divider2Index
print(key)
