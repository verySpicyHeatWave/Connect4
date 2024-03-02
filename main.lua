require 'dependencies'

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

colors = {
    [ 1] = {'red', 16711680},
    [ 2] = {'orange', 16744448},
    [ 3] = {'yellow', 16776960},
    [ 4] = {'light green', 8453888},
    [ 5] = {'green', 65280},
    [ 6] = {'teal', 65408},
    [ 7] = {'aqua', 65535},
    [ 8] = {'indigo', 33023},
    [ 9] = {'blue', 255},
    [10] = {'purple', 8388863},
    [11] = {'magenta', 16711935},
    [12] = {'pink', 16711808},
    [13] = {'white', 16777215}
}

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

    smallfont = love.graphics.newFont('lib/cartoon.ttf', 50)
    normalfont = love.graphics.newFont('lib/cartoon.ttf', 75)
    titlefont = love.graphics.newFont('lib/cartoon.ttf', 150)
    love.graphics.setFont(normalfont)

    love.window.setTitle('Connect Four')

    gameState = StateMachine {        
        ['play'] = function() return PlayState() end,
        ['menu'] = function() return MainMenu() end,
        ['select'] = function() return PlayerSelect() end
    }
    gameState:change('menu')
end



function love.resize(w, h)
    gameState:resize(w, h)
end



function love.update(dt)
    gameState:update(dt)
end



function love.mousepressed(x, y, button)
    gameState:mousepressed(x, y, button)
end



function love.keypressed(key)
    gameState:keypressed(key)
end



function love.draw()
    push:start()
    gameState:render()
    push:finish()
end



function setColorWith24BitVal(sum)
    tsum = sum
    blueG = tsum % 256

    tsum = (tsum - blueG) / 256
    greenG = tsum % (256)

    redG = (tsum - greenG) / 256
    love.graphics.setColor(love.math.colorFromBytes(redG, greenG, blueG, alpha))
end


function getDimmedColorValue(sum)
    tsum = sum
    blueG = tsum % 256

    tsum = (tsum - blueG) / 256
    greenG = tsum % (256)

    redG = (tsum - greenG) / 256
    
    newBlue = blueG / 5
    newGreen = greenG / 5
    newRed = redG / 5

    resp = newBlue + (newGreen * 256) + (newRed * 256 * 256)
    return resp
end



