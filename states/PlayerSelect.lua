PlayerSelect = Class{__includes = BaseState}

playernumber = 1

playerlist = {}
playername = false
caratsize = 0

function PlayerSelect:enter(enterParams)
    self.cpuplayer = enterParams
end


function PlayerSelect:init()
    playerlist[1] = {'', 0}
    self.sel = 1
    playernumber = 1
    caratsize = titlefont:getWidth('<')
    self.cpuplayer = false

    self.options = {}

    label = "<"
    x = normalfont:getWidth(label)
    self.options[0] = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 - 180 - caratsize),
        ['y'] = WINDOW_HEIGHT / 3 - 150,
        ['color'] = 13,
        ['sel'] = false,
        ['font'] = titlefont
    }
    
    label = ">"
    x = normalfont:getWidth(label)
    y = normalfont:getHeight()
    self.options[1] = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 + 180),
        ['y'] = WINDOW_HEIGHT / 3 - 150,
        ['color'] = 13,
        ['sel'] = false,
        ['font'] = titlefont
    }

    label = "next player"
    x = normalfont:getWidth(label)
    self.options[2] = {
        ['text'] = label,
        ['x'] = (WINDOW_WIDTH / 2 - x / 2),
        ['y'] = WINDOW_HEIGHT / 2 + 375,
        ['color'] = 13,
        ['sel'] = false,
        ['font'] = normalfont
    }
end



function PlayerSelect:update(dt)
    
    local msx, msy = love.mouse.getPosition()
    msx, msy = push:toGame(msx, msy)
    if (msx == nil or msy == nil) then return end
    local reduceMaxX   = WINDOW_WIDTH / 2 - 180
    local reduceMinX   = WINDOW_WIDTH / 2 - 180 - caratsize
    local increaseMaxX = WINDOW_WIDTH / 2 + 180 + caratsize
    local increaseMinX = WINDOW_WIDTH / 2 + 180
    local minY = WINDOW_HEIGHT / 3 - 95
    local maxY = WINDOW_HEIGHT / 3 - 20
    local enterMax = 

    if (msx < reduceMaxX and msx > reduceMinX) then
        if (msy > minY and msy < maxY) then 
            love.window.setTitle(msx .. '     ' .. msy .. '     In Range!') -- do the thing
        else            
            love.window.setTitle(msx .. '     ' .. msy)
        end
    elseif (msx < increaseMaxX and msx > increaseMinX) then
        if (msy > minY and msy < maxY) then 
            love.window.setTitle(msx .. '     ' .. msy .. '     In Range!') --do the thing
        else            
            love.window.setTitle(msx .. '     ' .. msy)
        end
    else
        love.window.setTitle(msx .. '     ' .. msy)
    end

    if (self.cpuplayer and playernumber == 2) then
        playername = 'CPU'
    end
end



function PlayerSelect:render()
    setColorWith24BitVal(colors[13][2])
    local str = 'Player ' .. playernumber
    love.graphics.setFont(titlefont)
    local x = titlefont:getWidth(str)
    love.graphics.print(str, WINDOW_WIDTH / 2 - x / 2, 50)

    if (playername) then
        x = titlefont:getWidth(playername)
        love.graphics.print(playername, WINDOW_WIDTH / 2 - x / 2, WINDOW_HEIGHT / 2 + 200)
    end
    
    love.graphics.setFont(normalfont)
    x = normalfont:getWidth(colors[self.sel][1])
    love.graphics.print(colors[self.sel][1], WINDOW_WIDTH / 2 - x / 2, WINDOW_HEIGHT / 3 + 50)

    str = "enter your name!"
    x = normalfont:getWidth(str)
    love.graphics.print(str, WINDOW_WIDTH / 2 - x / 2, WINDOW_HEIGHT / 2 + 50)

    setColorWith24BitVal(colors[self.sel][2])
    love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 3 - 50, 80)

    for i = 0, 2, 1 do
        love.graphics.setFont(self.options[i]['font'])
        x = self.options[i]['font']:getWidth(self.options[i]['text'])
        setColorWith24BitVal(colors[self.options[i]['color']][2])
        love.graphics.print(self.options[i]['text'], self.options[i]['x'], self.options[i]['y'])
    end
end



function PlayerSelect:mousepressed(x, y, button)
    
end



function PlayerSelect:keypressed(key)
    if (key == 'left') then        
        self:decrementSel()
        if playerlist[1][2] == colors[self.sel][2] then self:decrementSel() end
    elseif (key == 'right') then
        self:incrementSel()
        if playerlist[1][2] == colors[self.sel][2] then self:incrementSel() end
    elseif (key == 'return') then
        playerlist[playernumber] = {
            playername or colors[self.sel][1],
            colors[self.sel][2],
            false
        }
        playername = false
        playernumber = playernumber + 1
        if (playernumber > 2) then 
            playerlist[2][3] = self.cpuplayer
            gameState:change('play', playerlist) 
        end
        self:incrementSel()
        self.options[2]['text'] = 'ready to play!'
    end

    --love.window.setTitle(key)
    if (string.len(key) == 1) then
        if (not playername) then playername = "" end
        playername = playername .. key
    end

    if (key == 'backspace' and playername) then
        size = string.len(playername)
        if (size <= 1) then 
            playername = false 
        else
            playername = string.sub(playername, 1, size - 1)
        end
    end

    if (key == 'escape') then
        gameState:change('menu')
    end
end


function PlayerSelect:resize(w, h)
    push:resize(w, h)
end

function PlayerSelect:incrementSel() self.sel = (self.sel + 1 < 13) and (self.sel + 1) or 1 end
function PlayerSelect:decrementSel() self.sel = (self.sel - 1 > 0) and (self.sel - 1) or 12 end






