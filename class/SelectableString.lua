SelectableString = Class{}

function SelectableString:init(str, x, y, font, actionString)
    self.text = str
    self.font = font
    self.xmode = 'custom'
    if (x == 'center') then
        self.xmode = x
        self.x = WINDOW_WIDTH / 2 - (self.font:getWidth(self.text)) / 2
    else
        self.x = x
    end
    self.y = y
    
    self.clickbox = {
        ['xmin'] = self.x,
        ['xmax'] = self.x + self.font:getWidth(self.text),
        ['ymin'] = self.y,
        ['ymax'] = self.y + self.font:getHeight()
    }
    self.sel = false
    self.color = 13
    self.actionString = actionString
end



function SelectableString:setFont(font)
    self.font = font
    if (self.xmode == 'center') then self.x = WINDOW_WIDTH / 2 - (self.font:getWidth(self.text)) / 2 end    
end



function SelectableString:setText(str)
    self.text = str
    if (self.xmode == 'center') then self.x = WINDOW_WIDTH / 2 - (self.font:getWidth(self.text)) / 2 end
end



function SelectableString:defineClickBox(xmin, xmax, ymin, ymax)
    self.clickbox['xmin'] = xmin
    self.clickbox['xmax'] = xmax
    self.clickbox['ymin'] = ymin
    self.clickbox['ymax'] = ymax
end



function SelectableString:checkIfSelected(msx, msy)
    if (msx == nil or msy == nil) then return end
    if (msx > self.clickbox['xmin'] and msx < self.clickbox['xmax'] and msy > self.clickbox['ymin'] and msy < self.clickbox['ymax']) then
        self.sel = true
        self.color = 1
    else
        self.sel = false
        self.color = 13
    end
end



function SelectableString:print()
    love.graphics.setFont(self.font)
    setColorWith24BitVal(colors[self.color][2])
    love.graphics.print(self.text, self.x, self.y)
end



function SelectableString:getActionString()
    return self.actionString
end



function SelectableString:getText()
    return self.text
end



function SelectableString:isSelected()
    return self.sel
end