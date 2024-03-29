require 'dependencies'

ROWS = 6
COLS = 7
CELL_SIZE = 180
WINDOW_WIDTH = CELL_SIZE * 7.5
WINDOW_HEIGHT = CELL_SIZE * 7

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
    1) Set up state machine for machine player's difficulty setting
    2) Write different difficulty setting algorithms
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
        ['select'] = function() return PlayerSelect() end,
        ['difficulty'] = function() return DifficultySelect() end
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
    local tsum = sum
    local blueG = tsum % 256

    tsum = (tsum - blueG) / 256
    local greenG = tsum % (256)

    local redG = (tsum - greenG) / 256
    love.graphics.setColor(love.math.colorFromBytes(redG, greenG, blueG, alpha))
end


function getDimmedColorValue(sum)
    local tsum = sum
    local blueG = tsum % 256

    tsum = (tsum - blueG) / 256
    local greenG = tsum % (256)

    local redG = (tsum - greenG) / 256
    
    local newBlue = math.floor(blueG / 5)
    local newGreen = math.floor(greenG / 5)
    local newRed = math.floor(redG / 5)

    local resp = newBlue + (newGreen * 256) + (newRed * 256 * 256)
    return resp
end



