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
end



function PlayerSelect:update(dt)
    local msx = love.mouse.getX()
    local msy = love.mouse.getY()
    local reduceMaxX   = WINDOW_WIDTH / 2 - 180
    local reduceMinX   = WINDOW_WIDTH / 2 - 180 - caratsize
    local increaseMaxX = WINDOW_WIDTH / 2 + 180 + caratsize
    local increaseMinX = WINDOW_WIDTH / 2 + 180
    local minY = WINDOW_HEIGHT / 3 - 50
    local maxY = WINDOW_HEIGHT / 3 + 25

    if (msx < reduceMaxX and msx > reduceMinX) then
        if (msy > minY and msy < maxY) then 
            --love.window.setTitle(msx .. '     ' .. msy .. '     In Range!') -- do the thing
        else            
            --love.window.setTitle(msx .. '     ' .. msy)
        end
    elseif (msx < increaseMaxX and msx > increaseMinX) then
        if (msy > minY and msy < maxY) then 
            --love.window.setTitle(msx .. '     ' .. msy .. '     In Range!') --do the thing
        else            
            --love.window.setTitle(msx .. '     ' .. msy)
        end
    else
        --love.window.setTitle(msx .. '     ' .. msy)
    end

    if (self.cpuplayer and playernumber == 2) then
        playername = 'CPU'
    end

end



function PlayerSelect:render()
    setColorWith24BitVal(255 + (255*256) + (255*256*256))
    local str = 'Player ' .. playernumber
    love.graphics.setFont(titlefont)
    local x = titlefont:getWidth(str)
    love.graphics.print(str, WINDOW_WIDTH / 2 - x / 2, 50)
    love.graphics.print('<', WINDOW_WIDTH / 2 - 180 - caratsize, WINDOW_HEIGHT / 3 - 150)
    love.graphics.print('>', WINDOW_WIDTH / 2 + 180,             WINDOW_HEIGHT / 3 - 150)

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

function PlayerSelect:incrementSel() self.sel = (self.sel + 1 < 13) and (self.sel + 1) or 1 end
function PlayerSelect:decrementSel() self.sel = (self.sel - 1 > 0) and (self.sel - 1) or 12 end






