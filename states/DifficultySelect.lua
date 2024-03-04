DifficultySelect = Class{__includes = BaseState}

keyselect = 0

function DifficultySelect:enter(enterParams)
    self.playerlist = enterParams
end

function DifficultySelect:init()
    self.title = SelectableString('select CPU difficulty', 'center', 300, titlefont)
    self.options = {
        [0] = SelectableString('easy', 'center', WINDOW_HEIGHT / 2 - 75, normalfont, 'easy'),
        [1] = SelectableString('medium', 'center', WINDOW_HEIGHT / 2, normalfont, 'medium'),
        [2] = SelectableString('hard', 'center', WINDOW_HEIGHT / 2 + 75, normalfont, 'hard'),
    }
    self.playerlist = {}
end



function DifficultySelect:update(dt)
    local msx, msy = love.mouse.getPosition()
    msx, msy = push:toGame(msx, msy)
    if (msx == nil or msy == nil) then return end

    for i=0,2,1 do
        self.options[i]:checkIfSelected(msx, msy)
    end
end



function DifficultySelect:render()
    self.title:print()

    for i=0,2,1 do
        self.options[i]:print()
    end
end



function DifficultySelect:mousepressed(x, y, button)
    for i=0,2,1 do
        if (self.options[i]:isSelected()) then 
            self.playerlist[2][3] = self.options[i]:getActionString()
            gameState:change('play', self.playerlist)
        end
    end
end



function DifficultySelect:keypressed(key)
    local keyselect = -1
    if (key == 'up') then
        keyselect = (keyselect - 1) % 3
    elseif (key == 'down') then
        keyselect = (keyselect + 1) % 3
    elseif (key == 'return') then
        gameState:change(self.options[keyselect]['state'], keyselect == 0)
    end
end



function DifficultySelect:resize(w, h)
    push:resize(w, h)
end