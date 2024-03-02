PlayerSelect = Class{__includes = BaseState}

local playernumber = 1
local playerlist = {}
local playername = false

TESTVAR = ""

function PlayerSelect:enter(enterParams)
    self.cpuplayer = enterParams
end


function PlayerSelect:init()
    self.sel = 1
    self.currentPlayer = SelectableString("Player " .. playernumber, 'center', 50, titlefont)
    self.enterName = SelectableString("enter your name!", 'center', WINDOW_HEIGHT / 2 + 50, normalfont)
    self.colorLabel = SelectableString(colors[self.sel][1], 'center', WINDOW_HEIGHT / 3 + 50, normalfont)
    self.playerName = SelectableString("", 'center', WINDOW_HEIGHT / 2 + 200, titlefont)

    local caratsize = titlefont:getWidth('<')
    local reduceMaxX   = WINDOW_WIDTH / 2 - 180
    local reduceMinX   = WINDOW_WIDTH / 2 - 180 - caratsize
    local increaseMaxX = WINDOW_WIDTH / 2 + 180 + caratsize
    local increaseMinX = WINDOW_WIDTH / 2 + 180
    local minY = WINDOW_HEIGHT / 3 - 95
    local maxY = WINDOW_HEIGHT / 3 - 20

    self.options = {
        [0] = SelectableString("<", WINDOW_WIDTH / 2 - 180 - caratsize, WINDOW_HEIGHT / 3 - 150, titlefont),
        [1] = SelectableString(">", WINDOW_WIDTH / 2 + 180, WINDOW_HEIGHT / 3 - 150, titlefont),
        [2] = SelectableString("next player", 'center', WINDOW_HEIGHT / 2 + 375, normalfont)
    }    
    self.options[0]:defineClickBox(reduceMinX, reduceMaxX, minY, maxY)
    self.options[1]:defineClickBox(increaseMinX, increaseMaxX, minY, maxY)    

    playerlist[1] = {'', 0}
    playernumber = 1
    self.cpuplayer = false
end



function PlayerSelect:update(dt)    
    local msx, msy = love.mouse.getPosition()
    msx, msy = push:toGame(msx, msy)
    if (msx == nil or msy == nil) then return end
    for i=0,2,1 do
        self.options[i]:checkIfSelected(msx, msy)
    end
    if (self.cpuplayer and playernumber == 2) then
        self.playerName:setText('CPU')
    end
end



function PlayerSelect:render()
    self.currentPlayer:print()
    self.enterName:print()
    self.colorLabel:print()
    for i=0,2,1 do
        self.options[i]:print()
    end
    if (playername) then self.playerName:print() end
    
    setColorWith24BitVal(colors[self.sel][2])
    love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 3 - 50, 80)
end



function PlayerSelect:mousepressed(x, y, button)
    local selection = -1
    for i=0,2,1 do
        if (self.options[i]:isSelected()) then selection = i end
    end
    if (selection == 0) then self:decrementSel() end
    if (selection == 1) then self:incrementSel() end
    if (selection == 2) then self:lockInPlayer() end
end



function PlayerSelect:keypressed(key)
    if (key == 'left') then
        self:decrementSel()
    elseif (key == 'right') then
        self:incrementSel()
    elseif (key == 'return') then
        self:lockInPlayer()
    end
    
    if (string.len(key) == 1) then
        if (not playername) then playername = "" end
        playername = playername .. key
        self.playerName:setText(playername)
    end

    if (key == 'backspace' and playername) then
        size = string.len(playername)
        if (size <= 1) then 
            playername = false 
        else
            playername = string.sub(playername, 1, size - 1)
        end
        self.playerName:setText(playername)
    end

    if (key == 'escape') then
        gameState:change('menu')
    end
end


function PlayerSelect:resize(w, h)
    push:resize(w, h)
end



function PlayerSelect:incrementSel() 
    self.sel = (self.sel + 1 < 13) and (self.sel + 1) or 1
    if playerlist[1][2] == colors[self.sel][2] then self.sel = (self.sel + 1 < 13) and (self.sel + 1) or 1 end
    self.colorLabel:setText(colors[self.sel][1])
end



function PlayerSelect:decrementSel() 
    self.sel = (self.sel - 1 > 0) and (self.sel - 1) or 12
    if playerlist[1][2] == colors[self.sel][2] then self.sel = (self.sel - 1 > 0) and (self.sel - 1) or 12 end
    self.colorLabel:setText(colors[self.sel][1])
end



function PlayerSelect:lockInPlayer()
    playerlist[playernumber] = {
        playername or colors[self.sel][1],
        colors[self.sel][2],
        false
    }
    playernumber = playernumber + 1
    if (playernumber > 2) then 
        playerlist[2][3] = self.cpuplayer
        gameState:change('play', playerlist) 
    end
    playername = false
    self:incrementSel()
    self.currentPlayer:setText("Player ".. playernumber)
    self.options[2]:setText('ready to play!')
    self.playerName:setText(playername)
end






