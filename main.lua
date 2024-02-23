push = require 'lib/push'
Class = require 'lib/class'

require 'class/Space'

ROWS = 6
COLS = 7
CELL_SIZE = 180
WINDOW_WIDTH = CELL_SIZE * 7.5
WINDOW_HEIGHT = CELL_SIZE * 7

grid = {}
players = {'red', 'yellow'}
turnCount = 1
gameCount = 1
winner = 'none'

--[[
    todo:
    1) Allow user to choose colors (need state machine to set up menu, I think)
    2) Create state machine for main menu, 1p vs 2p game
    3) Set up state machine for machine player's difficulty setting
    4) Write different difficulty setting algorithms
]]



function love.load()
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    font = love.graphics.newFont('lib/cartoon.ttf', 75)
    love.graphics.setFont(font)

    love.window.setTitle('Connect Four, but Minimaxed!')

    for i = 1, COLS, 1 do
        grid[i] = {}
        for j = 1, ROWS, 1 do
            grid[i][j] = Space(i, j, CELL_SIZE)
        end
    end
end



function love.update(dt) 
    if (gameOver()) then return end
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            if (gameHasAWinner(i, j)) then
                winner = grid[i][j].claimedBy
            end
        end
        if (gameOver()) then break end
    end   
end



function love.mousepressed(x, y, button)
    if (gameOver()) then return end
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            if (grid[i][j]:isFalling()) then return end
        end
    end
    xpos = x - CELL_SIZE / 4
    xpos = xpos - (xpos % CELL_SIZE)
    xpos = xpos / CELL_SIZE + 1
    xpos = (xpos > 1) and xpos or 1
    xpos = (xpos < COLS) and xpos or COLS
    if (xpos > COLS) then xpos = COLS end
    for j = 6, 1, -1 do
        if (not grid[xpos][j]:isFilled()) then
            grid[xpos][j]:fill(players[turnCount])
            turnCount = (turnCount ) % 2 + 1
            break
        end
    end  
end



function love.keypressed(key)
    if (key == 'r') then
        resetGame()
    end
end



function love.draw()
    push:start()
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            grid[i][j]:render()
        end
    end
    love.graphics.setColor(255,255,255,255)
    printMessage()
    push:finish()
end



function gameHasAWinner(i, j)
    if (i < 5 and           horizontalCheck(i, j) == 4)     then return true end
    if (i < 5 and j < 4 and negDiagonalCheck(i, j) == 4)    then return true end
    if (j < 4 and           verticalCheck(i, j) == 4)       then return true end
    if (i > 3 and j < 4 and posDiagonalCheck(i, j) == 4)    then return true end    
    return false
end



function gameOver()
    return winner ~= 'none'
end



function horizontalCheck(i, j)
    if (not grid[i][j]:isFilled()) then return 0 end
    count = 1
    for x = 1, 3, 1 do
        if (grid[i][j].claimedBy == grid[i + x][j].claimedBy) then count = count + 1 end
    end
    if (count == 4) then
        for x = 0, 3, 1 do
            grid[i + x][j]:winningSlot()
        end
    end
    return count
end



function verticalCheck(i, j, player)
    if (grid[i][j].claimedBy == 'none') then return 0 end
    count = 1
    for y = 1, 3, 1 do
        if (grid[i][j].claimedBy == grid[i][j + y].claimedBy) then
            count = count + 1
        end
    end
    if (count == 4) then
        for y = 0, 3, 1 do
            grid[i][j + y]:winningSlot()
        end
    end
    return count
end



function posDiagonalCheck(i, j, player)
    if (grid[i][j].claimedBy == 'none') then return 0 end
    count = 1
    for diag = 1, 3, 1 do
        if (grid[i][j].claimedBy == grid[i - diag][j + diag].claimedBy) then
            count = count + 1
        end
    end
    if (count == 4) then
        for q = 0, 3, 1 do
            grid[i - q][j + q]:winningSlot()
        end
    end
    return count
end



function negDiagonalCheck(i, j, player)
    if (grid[i][j].claimedBy == 'none') then return 0 end
    count = 1
    for diag = 1, 3, 1 do
        if (grid[i][j].claimedBy == grid[i + diag][j + diag].claimedBy) then
            count = count + 1
        end
    end
    if (count == 4) then
        for q = 0, 3, 1 do
            grid[i + q][j + q]:winningSlot()
        end
    end
    return count
end



function printMessage()
    message = ''
    if (gameOver()) then 
        message = winner .. ' wins!'
    else
        message = players[turnCount] .. '\'s turn!'
    end
    w = font:getWidth(message) / 2
    love.graphics.print(message, (WINDOW_WIDTH / 2) - w, 10)
end



function resetGame()
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            grid[i][j]:reset()
        end
    end
    winner = 'none'
    turnCount = (gameCount % 2) + 1
    gameCount = 1 + gameCount
end
