local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day8/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local lines = {}
for w in fileContent:gmatch("(.-)\n") do
  table.insert(lines, w)
end

local rowLen = #lines[1]
local colLen = #lines

local function isVisible(i, j)
  local height = tonumber(lines[i]:sub(j, j))
  local count = 0
  for k = 1, i - 1 do
    local h = tonumber(lines[k]:sub(j, j))
    if h >= height then
      count = count + 1
      break
    end
  end
  for k = i + 1, colLen do
    local h = tonumber(lines[k]:sub(j, j))
    if h >= height then
      count = count + 1
      break
    end
  end
  for k = 1, j - 1 do
    local h = tonumber(lines[i]:sub(k, k))
    if h >= height then
      count = count + 1
      break
    end
  end
  for k = j + 1, rowLen do
    local h = tonumber(lines[i]:sub(k, k))
    if h >= height then
      count = count + 1
      break
    end
  end
  return count < 4
end

local count = 0
for i = 2, colLen - 1 do
  for j = 2, rowLen - 1 do
    if isVisible(i, j) then
      count = count + 1
    end
  end
end

count = count + rowLen * 2 + colLen * 2 - 4

print(count)

local function scenicScore(i, j)
  local height = tonumber(lines[i]:sub(j, j))
  local countTop = 0
  local countBottom = 0
  local countLeft = 0
  local countRight = 0
  for k = i - 1, 1, -1 do
    countTop = countTop + 1
    local h = tonumber(lines[k]:sub(j, j))
    if h >= height then
      break
    end
  end
  for k = i + 1, colLen do
    countBottom = countBottom + 1
    local h = tonumber(lines[k]:sub(j, j))
    if h >= height then
      break
    end
  end
  for k = j - 1, 1, -1 do
    countLeft = countLeft + 1
    local h = tonumber(lines[i]:sub(k, k))
    if h >= height then
      break
    end
  end
  for k = j + 1, rowLen do
    countRight = countRight + 1
    local h = tonumber(lines[i]:sub(k, k))
    if h >= height then
      break
    end
  end
  -- print(i, j, height, countTop, countLeft, countRight, countBottom)
  return countTop * countBottom * countLeft * countRight
end

local maxScore = 0
for i = 2, colLen - 1 do
  for j = 2, rowLen - 1 do
    local score = scenicScore(i, j)
    if score > maxScore then
      maxScore = score
    end
  end
end

print(maxScore)
