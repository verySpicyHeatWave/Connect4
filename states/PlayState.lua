PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(100, 10)
    self.tileMap = self.level.tileMap
    self.background = math.random(3)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6

    self.player = Player({
        x = 0, y = 0,
        width = 16, height = 20,
        texture = 'green-alien',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level
    })

    self:spawnEnemies()

    self.player:changeState('falling')
end


function PlayState:update(dt)
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


function PlayState:render()
    for i=1, COLS, 1 do
        for j=1, ROWS, 1 do
            grid[i][j]:render()
        end
    end
    love.graphics.setColor(255,255,255,255)
    printMessage()
end


function PlayState:resetGame()

end