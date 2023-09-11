local open = io.open

local function read_file(path)
  local file = open(path, "rb")  -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day11/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for w in fileContent:gmatch("(.-)\n") do
  table.insert(lines, w)
end

local monkeys = {}

local function splitStringToNumbers(input)
  local result = {}
  for number in input:gmatch("%s*([^,]+)%s*,?") do
    table.insert(result, tonumber(number))
  end
  return result
end

for i = 1, #lines, 7 do
  local monkeyIdx = tonumber(lines[i]:sub(8, 8))
  local startingItems = splitStringToNumbers(lines[i + 1]:sub(19, #lines[i + 1]))
  local operation = lines[i + 2]:sub(20, #lines[i + 2])
  local test = tonumber(lines[i + 3]:sub(22, #lines[i + 3]))
  local ifTrue = tonumber(lines[i + 4]:sub(30, #lines[i + 4]))
  local ifFalse = tonumber(lines[i + 5]:sub(31, #lines[i + 5]))
  monkeys[monkeyIdx] = {
    startingItems = startingItems,
    operation = operation,
    test = test,
    ifTrue = ifTrue,
    ifFalse = ifFalse,
    inspect = 0,
  }
end

local function getVal(symbol, worry)
  if symbol == "old" then
    return worry
  else
    return tonumber(symbol)
  end
end

local function doOp(worry, operation)
  local left, op, right = operation:match("(.+)%s(.+)%s(.+)")
  local leftVal = getVal(left, worry)
  local rightVal = getVal(right, worry)
  if op == '*' then
    return leftVal * rightVal
  elseif op == '+' then
    return leftVal + rightVal
  end
end

local function doTest(worry, test)
  return worry % test == 0
end

for i = 1, 20 do
  for j = 0, #monkeys do
    local monkey = monkeys[j]
    local items = monkey.startingItems
    for k = 1, #items do
      monkey.inspect = monkey.inspect + 1
      local worry = math.floor(doOp(items[k], monkey.operation) / 3)
      if (doTest(worry, monkey.test)) then
        table.insert(monkeys[monkey.ifTrue].startingItems, worry)
      else
        local otherMonkey = monkeys[monkey.ifFalse]
        table.insert(monkeys[monkey.ifFalse].startingItems, worry)
      end
    end
    monkey.startingItems = {}
  end
end

local function getTop2Monkeys()
  local top1 = 0
  local top2 = 0
  for i = 0, #monkeys do
    local monkey = monkeys[i]
    if monkey.inspect > top1 then
      top2 = top1
      top1 = monkey.inspect
    elseif monkey.inspect > top2 then
      top2 = monkey.inspect
    end
  end
  return top1, top2
end

local top1, top2 = getTop2Monkeys()
local result = top1 * top2
print(result)
