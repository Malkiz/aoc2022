local open = io.open

local function read_file(path)
  local file = open(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local fileContent = read_file("lua/day2/input.txt");

if not fileContent then
  print("File not found")
  os.exit()
end

local moveDict = {
  ["A"] = "Rock",
  ["B"] = "Paper",
  ["C"] = "Scissors",
}

local outcomeDict = {
  ["X"] = "Lose",
  ["Y"] = "Draw",
  ["Z"] = "Win",
}

local myMove = {
  ["RockLose"] = "Scissors",
  ["RockWin"] = "Paper",
  ["RockDraw"] = "Rock",
  ["PaperLose"] = "Rock",
  ["PaperWin"] = "Scissors",
  ["PaperDraw"] = "Paper",
  ["ScissorsLose"] = "Paper",
  ["ScissorsWin"] = "Rock",
  ["ScissorsDraw"] = "Scissors",
}

local scoreDict = {
  ["Win"] = 6,
  ["Lose"] = 0,
  ["Draw"] = 3,
  ["Rock"] = 1,
  ["Paper"] = 2,
  ["Scissors"] = 3,
}

local totalScore = 0
for w in fileContent:gmatch("(.-)\n") do
  local op, outcome = w:match("(.+) (.+)")
  local opMove = moveDict[op]
  local outcomeValue = outcomeDict[outcome]
  local move = myMove[opMove .. outcomeValue]
  local score = scoreDict[move] + scoreDict[outcomeValue]
  totalScore = totalScore + score
end

print(totalScore)
