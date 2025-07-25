
-- Knight's tour
-- https://rosettacode.org/wiki/Knight%27s_tour#Lua

local boardsize = 8
local knightmoves = {{1, -2}, {2, -1}, {2, 1}, {1, 2}, {-1, 2}, {-2, 1}, {-2, -1}, {-1, -2}}

--[[
  . 5 . 4 .
  6 . . . 3
  . . N . .
  7 . . . 2
  . 8 . 1 .
]]

local unvisited = 0

function TryNextMove(aBoard, aX, aY)
  if aBoard[aX][aY] >= #knightmoves then
    return false
  else
    local x2, y2 =
      aX + knightmoves[aBoard[aX][aY] + 1][1],
      aY + knightmoves[aBoard[aX][aY] + 1][2]
    return (x2 >= 1) and (x2 <= boardsize) and (y2 >= 1) and (y2 <= boardsize) and (aBoard[x2][y2] == unvisited)
  end
end

local board = {}

for x = 1, boardsize do
  board[x] = {}
  for y = 1, boardsize do
    board[x][y] = unvisited
  end
end

local path = {}
local x, y = 1, 1
path[1] = {x, y}

function PathToName(aIndex)
  return string.format(
    '%s%d',
    string.sub('abcdefgh', path[aIndex][1], path[aIndex][1]),
    path[aIndex][2]
  )
end

repeat
  if TryNextMove(board, x, y) then
    board[x][y] = board[x][y] + 1
    x, y = x + knightmoves[board[x][y]][1], y + knightmoves[board[x][y]][2]
    path[#path + 1] = {x, y}
  else
    if board[x][y] >= #knightmoves then
      board[x][y] = unvisited
      path[#path] = nil
      
      if #path == 0 then
        break
      end
      
      x, y = path[#path][1], path[#path][2]
    end
    
    board[x][y] = board[x][y] + 1    
  end
until #path == boardsize ^ 2

if #path > 0 then
  local a = PathToName(1)
  for i = 2, #path do
    local b = PathToName(i)
    print(a .. b)
    a = b
  end
end
