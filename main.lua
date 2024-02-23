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
        ['menu'] = function() return MainMenu() end
    }
    gameState:change('menu')
end


function love.resize(w, h)
    push:resize(w, h)
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
