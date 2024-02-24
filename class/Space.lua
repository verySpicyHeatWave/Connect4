Space = Class{}
WHITE = 255 + (255*256) + (255*256*256)

function Space:init(x, y, size)
    self.box = {
        ['x'] = (x - 1) * size + (size / 4),
        ['y'] = (y - 1) * size + (size / 2),
        ['size'] = size * .98,
        ['col'] = WHITE,
        ['mode'] = 'line',
        ['a'] = 255
    }
    
    self.circle = {        
        ['x'] = self.box['x'] + (size / 2),
        ['y'] = self.box['y'] + (size / 2),
        ['size'] = size * .4,
        ['col'] = 0,
        ['drop'] = self.box['y'] + (size / 2) + 1
    }

    self.claimedBy = 'none'
end



function Space:fill(player)
    self.claimedBy = player[1]
    self.circle['col'] = player[2]
    self.circle['drop'] = 0
end



function Space:reset()
    self.claimedBy = 'none'
    self.circle['col'] = 0
    self.circle['g'] = 0
    self.circle['b'] = 0
    self.circle['drop'] = self.circle['y'] + 1
    self.box['col'] = WHITE
    self.box['mode'] = 'line'
end



function Space:isFilled()
    return self.claimedBy ~= 'none'
end



function Space:winningSlot()
    self.box['col'] = getDimmedColorValue(self.circle['col'])
    self.box['mode'] = 'fill'
end



function Space:isFalling()
    return (self.circle['drop'] < self.circle['y'])
end


function Space:render()    
    setColorWith24BitVal(self.box['col'])
    love.graphics.rectangle(self.box['mode'], self.box['x'], self.box['y'], self.box['size'], self.box['size'])

    setColorWith24BitVal(self.circle['col'])
    love.graphics.circle('fill', self.circle['x'], math.min(self.circle['drop'], self.circle['y']), self.circle['size'])

    if (self:isFilled() and self:isFalling()) then
        self.circle['drop'] = self.circle['drop'] + 50
    end
end
