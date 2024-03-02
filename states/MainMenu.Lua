MainMenu = Class{__includes = BaseState}

keyselect = 0

function MainMenu:init()
    local label = "Connect Four!"
    local x = titlefont:getWidth(label)
    local y = 0
    self.title = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 - x / 2),
        ['y'] = 300,
        ['color'] = {255,255,255,255}
    }
    
    label = "made by B. Cobb  -  2024"
    x = smallfont:getWidth(label)
    y = titlefont:getHeight()
    self.name = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 - x / 2),
        ['y'] = self.title['y'] + y,
        ['color'] = {255,255,255,255}
    }

    self.options = {}

    label = "one player"
    x = normalfont:getWidth(label)
    self.options[0] = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 - x / 2),
        ['y'] = 800,
        ['color'] = {255,255,255,255},
        ['sel'] = false,
        ['state'] = 'select'
    }
    
    label = "two player"
    x = normalfont:getWidth(label)
    y = normalfont:getHeight()
    self.options[1] = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 - x / 2),
        ['y'] = self.options[0]['y'] + y,
        ['color'] = {255,255,255,255},
        ['sel'] = false,
        ['state'] = 'select'
    }

    label = "toggle music"
    x = normalfont:getWidth(label)
    self.options[2] = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 - x / 2),
        ['y'] = self.options[1]['y'] + y,
        ['color'] = {255,255,255,255},
        ['sel'] = false,
        ['state'] = 'menu'
    }

    self.labelWidth = x
    self.labelHeight = y
    self.msx = 2
    self.msy = 2
end



function MainMenu:update(dt)
    self.msx, self.msy = love.mouse.getPosition()
    self.msx, self.msy = push:toGame(self.msx, self.msy)
    if (self.msx == nil or self.msy == nil) then return end
    
    lblupperbound = WINDOW_WIDTH / 2 + self.labelWidth / 2
    lbllowerbound = WINDOW_WIDTH / 2 - self.labelWidth / 2
    if  (self.msx >= lblupperbound or self.msx <= lbllowerbound) then return end
    for i=0,2,1 do
        if (self.msy > self.options[i]['y'] and self.msy < self.options[i]['y'] + self.labelHeight) then
            self.options[i]['color'] = {255,0,0,255}
            self.options[i]['sel'] = true
        else
            self.options[i]['color'] = {255,255,255,255}
            self.options[i]['sel'] = false
        end
    end

    -- for i=0,2,1 do
    --     if (i == keyselect) then
    --         self.options[i]['color'] = {255,0,0,255}
    --         self.options[i]['sel'] = true
    --     else
    --         self.options[i]['color'] = {255,255,255,255}
    --         self.options[i]['sel'] = false
    --     end
    -- end
end



function MainMenu:render()

    love.graphics.setColor(love.math.colorFromBytes(255,255,255,255))

    love.graphics.setFont(titlefont)
    love.graphics.print(self.title['text'], self.title['x'], self.title['y'])

    love.graphics.setFont(smallfont)
    love.graphics.print(self.name['text'], self.name['x'], self.name['y'])


    love.graphics.setFont(normalfont)
    for i=0,2,1 do
        love.graphics.setColor(self.options[i]['color'])
        love.graphics.print(self.options[i]['text'], self.options[i]['x'], self.options[i]['y'])
    end
end



function MainMenu:mousepressed(x, y, button)
    selection = -1
    for i=0,2,1 do
        if (self.options[i]['sel']) then 
            selection = i 
        end
    end

    if (selection == 1) then
        gameState:change('select')
    end
end



function MainMenu:keypressed(key)
    if (key == 'up') then
        keyselect = (keyselect - 1) % 3
    elseif (key == 'down') then
        keyselect = (keyselect + 1) % 3
    elseif (key == 'return') then
        gameState:change(self.options[keyselect]['state'], keyselect == 0)
    end
    --if up arrow key, move cursor selection up
    --if down arrow key, move cursor selector down
    --if enter key, choose selected option

end



function MainMenu:resize(w, h)
    push:resize(w, h)
end



function setColorWith24BitVal(sum)
    tsum = sum
    blueG = tsum % 256

    tsum = (tsum - blueG) / 256
    greenG = tsum % (256)

    redG = (tsum - greenG) / 256
    love.graphics.setColor(love.math.colorFromBytes(redG, greenG, blueG))
end