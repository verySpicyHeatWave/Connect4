PlayState = Class{__includes = BaseState}


function PlayState:init()
    self.grid = {}
    self.players = {'red', 'yellow'}
    self.turnCount = 1
    self.gameCount = 1
    self.winner = 'none'
    
    for i = 1, COLS, 1 do
        self.grid[i] = {}
        for j = 1, ROWS, 1 do
            self.grid[i][j] = Space(i, j, CELL_SIZE)
        end
    end


end


function PlayState:update(dt)
    if (self:gameOver()) then return end
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            if (self:gameHasAWinner(i, j)) then
                self.winner = self.grid[i][j].claimedBy
            end
        end
        if (self:gameOver()) then break end
    end
end


function PlayState:render()
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            self.grid[i][j]:render()
        end
    end
    love.graphics.setColor(255,255,255,255)
    self:printMessage()
end


function PlayState:resetGame()
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            self.grid[i][j]:reset()
        end
    end
    self.winner = 'none'
    self.turnCount = (self.gameCount % 2) + 1
    self.gameCount = 1 + self.gameCount
end


function PlayState:mousepressed(x, y, button)
    if (self:gameOver()) then return end
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            if (self.grid[i][j]:isFalling()) then return end
        end
    end
    xpos = x - CELL_SIZE / 4
    xpos = xpos - (xpos % CELL_SIZE)
    xpos = xpos / CELL_SIZE + 1
    xpos = (xpos > 1) and xpos or 1
    xpos = (xpos < COLS) and xpos or COLS
    if (xpos > COLS) then xpos = COLS end
    for j = 6, 1, -1 do
        if (not self.grid[xpos][j]:isFilled()) then
            self.grid[xpos][j]:fill(self.players[self.turnCount])
            self.turnCount = (self.turnCount ) % 2 + 1
            break
        end
    end  

end



function PlayState:keypressed(key)
    if (key == 'r') then
        self:resetGame()
    end
end



function PlayState:gameHasAWinner(i, j)
    if (i < 5 and           self:horizontalCheck(i, j) == 4)     then return true end
    if (i < 5 and j < 4 and self:negDiagonalCheck(i, j) == 4)    then return true end
    if (j < 4 and           self:verticalCheck(i, j) == 4)       then return true end
    if (i > 3 and j < 4 and self:posDiagonalCheck(i, j) == 4)    then return true end    
    return false
end



function PlayState:gameOver()
    return self.winner ~= 'none'
end



function PlayState:horizontalCheck(i, j)
    if (not self.grid[i][j]:isFilled()) then return 0 end
    count = 1
    for x = 1, 3, 1 do
        if (self.grid[i][j].claimedBy == self.grid[i + x][j].claimedBy) then count = count + 1 end
    end
    if (count == 4) then
        for x = 0, 3, 1 do
            self.grid[i + x][j]:winningSlot()
        end
    end
    return count
end



function PlayState:verticalCheck(i, j, player)
    if (self.grid[i][j].claimedBy == 'none') then return 0 end
    count = 1
    for y = 1, 3, 1 do
        if (self.grid[i][j].claimedBy == self.grid[i][j + y].claimedBy) then
            count = count + 1
        end
    end
    if (count == 4) then
        for y = 0, 3, 1 do
            self.grid[i][j + y]:winningSlot()
        end
    end
    return count
end



function PlayState:posDiagonalCheck(i, j, player)
    if (self.grid[i][j].claimedBy == 'none') then return 0 end
    count = 1
    for diag = 1, 3, 1 do
        if (self.grid[i][j].claimedBy == self.grid[i - diag][j + diag].claimedBy) then
            count = count + 1
        end
    end
    if (count == 4) then
        for q = 0, 3, 1 do
            self.grid[i - q][j + q]:winningSlot()
        end
    end
    return count
end



function PlayState:negDiagonalCheck(i, j, player)
    if (self.grid[i][j].claimedBy == 'none') then return 0 end
    count = 1
    for diag = 1, 3, 1 do
        if (self.grid[i][j].claimedBy == self.grid[i + diag][j + diag].claimedBy) then
            count = count + 1
        end
    end
    if (count == 4) then
        for q = 0, 3, 1 do
            self.grid[i + q][j + q]:winningSlot()
        end
    end
    return count
end



function PlayState:printMessage()
    message = ''
    if (self:gameOver()) then 
        message = self.winner .. ' wins!'
    else
        message = self.players[self.turnCount] .. '\'s turn!'
    end
    w = font:getWidth(message) / 2
    love.graphics.print(message, (WINDOW_WIDTH / 2) - w, 10)
end