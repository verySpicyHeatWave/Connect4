MainMenu = Class{__includes = BaseState}

keyselect = 0

function MainMenu:init()
    self.title = SelectableString('Connect Four!', 'center', 300, titlefont)
    self.name = SelectableString('made by B. Cobb  -  2024', 'center', 450, smallfont)
    self.options = {
        [0] = SelectableString('one player', 'center', 800, normalfont, 'select'),
        [1] = SelectableString('two player', 'center', 875, normalfont, 'select'),
        [2] = SelectableString('toggle music', 'center', 950, normalfont, 'menu'),
    }
end



function MainMenu:update(dt)
    local msx, msy = love.mouse.getPosition()
    msx, msy = push:toGame(msx, msy)
    if (msx == nil or msy == nil) then return end

    for i=0,2,1 do
        self.options[i]:checkIfSelected(msx, msy)
    end
end



function MainMenu:render()
    self.title:print()
    self.name:print()

    for i=0,2,1 do
        self.options[i]:print()
    end
end



function MainMenu:mousepressed(x, y, button)
    for i=0,2,1 do
        if (self.options[i]:isSelected()) then 
            gameState:change(self.options[i]:getActionString())
        end
    end
end



function MainMenu:keypressed(key)
    local keyselect = -1
    if (key == 'up') then
        keyselect = (keyselect - 1) % 3
    elseif (key == 'down') then
        keyselect = (keyselect + 1) % 3
    elseif (key == 'return') then
        gameState:change(self.options[keyselect]['state'], keyselect == 0)
    end
end



function MainMenu:resize(w, h)
    push:resize(w, h)
end