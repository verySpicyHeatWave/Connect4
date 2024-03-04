CPUPlayer = Class{}

function CPUPlayer:init(difficulty, players)
    self.difficulty = difficulty
    self.timer = 0
    self.players = {players[1][1], players[2][1]}
end



function CPUPlayer:nextMove(tGrid)
    self:resetTimer()
    if (self.difficulty == 'easy') then
        return self:easyMove()
    elseif (self.difficulty == 'medium') then
        return self:mediumMove(tGrid)
    elseif (self.difficulty == 'hard') then
        return self:hardMove(tGrid)
    end
end



function CPUPlayer:easyMove()
    return math.random(1, 7)
end



function CPUPlayer:mediumMove(tGrid)


    return math.random(1, 7)
end



function CPUPlayer:hardMove(tGrid)
    local colCheck = {}
    for i = 1, COLS, 1 do
        colCheck[i] = self:recursiveMoveCheck(tGrid, i, 0, 2)
    end
    
    local resp = {1, -1000}
    local windowmessage = ""
    for i = 1, COLS, 1 do
        if (not colCheck[i]) then goto continue end
        if (resp[2] < colCheck[i][2]) then resp = colCheck[i] end
        windowmessage = windowmessage .. colCheck[i][1] .. "   " .. colCheck[i][2] .. "       "
        ::continue::
    end
    love.window.setTitle(windowmessage)
    return resp[1]
end



function CPUPlayer:timeToMove(dt)
    self.timer = self.timer + dt
    return (self.timer >= 1.3)
end



function CPUPlayer:resetTimer()
    self.timer = 0
end



function CPUPlayer:isActive()
    return self.difficulty
end



function CPUPlayer:recursiveMoveCheck(tGrid, column, depth, turn)
    tRow = 0
    for j = ROWS, 1, -1 do
        if (tGrid[column][j] ~= 'none') then
            tGrid[column][j] = self.players[turn]
            tRow = j
            break
        end
    end

    for i = 1, COLS, 1 do
        for j = 1, ROWS, 1 do
            if self:moveIsAWinner(tGrid, self.players[turn]) then 
                --tGrid[column][tRow] = 'none'
                if self.players[turn] == 'CPU' then return {column, (100 - depth)} end
                return {column, (-100 + depth)}
            end
        end
    end


    if (self:gridIsFull(tGrid)) then return false end

    local colCheck = {}
    for i = 1, COLS, 1 do
        colCheck[i] = self:recursiveMoveCheck(tGrid, i, (depth + 1), ((turn % 2) + 1))
    end
    local resp = {-1000, -1000}
    for i = 1, COLS, 1 do
        if (colCheck[i]) then
            if (resp[2] < colCheck[i][2]) then resp = colCheck[i] end
        end
    end
    return resp
end



function CPUPlayer:gridIsFull(tGrid)
    for j = 1, ROWS, 1 do
        for i = 1, COLS, 1 do
            if tGrid[i][j] == 'none' then return false end
        end
    end
    return true
end



function CPUPlayer:moveIsAWinner(tGrid, player)
    for i = 1, COLS, 1 do
        for j = 1, ROWS, 1 do
            if (i < 5 and           self:horizontalCheck(tGrid, i, j, player) == 4)     then return true end
            if (i < 5 and j < 4 and self:negDiagonalCheck(tGrid, i, j, player) == 4)    then return true end
            if (j < 4 and           self:verticalCheck(tGrid, i, j, player) == 4)       then return true end
            if (i > 3 and j < 4 and self:posDiagonalCheck(tGrid, i, j, player) == 4)    then return true end
        end
    end
    return false
end


function CPUPlayer:horizontalCheck(tGrid, i, j, player)
    if (tGrid[i][j] ~= player) then return 0 end
    count = 1
    for x = 1, 3, 1 do
        if (tGrid[i + x][j] == player) then count = count + 1 end
    end
    return count
end



function CPUPlayer:verticalCheck(tGrid, i, j, player)
    if (tGrid[i][j] ~= player) then return 0 end
    count = 1
    for y = 1, 3, 1 do
        if (tGrid[i][j + y] == player) then
            count = count + 1
        end
    end
    return count
end



function CPUPlayer:posDiagonalCheck(tGrid, i, j, player)
    if (tGrid[i][j] ~= player) then return 0 end
    count = 1
    for diag = 1, 3, 1 do
        if (tGrid[i - diag][j + diag] == player) then
            count = count + 1
        end
    end
    return count
end



function CPUPlayer:negDiagonalCheck(tGrid, i, j, player)
    if (tGrid[i][j] ~= player) then return 0 end
    count = 1
    for diag = 1, 3, 1 do
        if (tGrid[i + diag][j + diag] == player) then
            count = count + 1
        end
    end
    return count
end


--[[
CPU player should:
    Have its own timer to make the wait feel natural
    Return column numbers for moves based on its difficulty settings
    Does not need render or draw functions, just an initializer, a field to store its difficulty, and some algorithm functins

    EASY mode will just return a random number
    MEDIUM mode will perform a minimax but will not account for number of moves
    HARD mode will perform the minimax AND will account for number of moves in its calculus
]]