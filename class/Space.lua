Space = Class{}

colors = {
    ['red'] = {
        ['r'] = 255,
        ['g'] = 0, 
        ['b'] = 0},
    ['yellow'] = {
        ['r'] = 255,
        ['g'] = 255, 
        ['b'] = 0},
}

function Space:init(x, y, size)
    self.box = {
        ['x'] = (x - 1) * size + (size / 4),
        ['y'] = (y - 1) * size + (size / 2),
        ['size'] = size * .98,
        ['r'] = 255,
        ['g'] = 255,
        ['b'] = 255,
        ['mode'] = 'line'
    }
    
    self.circle = {        
        ['x'] = self.box['x'] + (size / 2),
        ['y'] = self.box['y'] + (size / 2),
        ['size'] = size * .4,
        ['r'] = 0,
        ['g'] = 0,
        ['b'] = 0,
        ['drop'] = self.box['y'] + (size / 2) + 1
    }

    self.claimedBy = 'none'
end



function Space:fill(player)
    self.claimedBy = player
    self.circle['r'] = colors[player]['r']
    self.circle['g'] = colors[player]['g']
    self.circle['b'] = colors[player]['b']
    self.circle['drop'] = 0
end



function Space:reset()
    self.claimedBy = 'none'
    self.circle['r'] = 0
    self.circle['g'] = 0
    self.circle['b'] = 0
    self.circle['drop'] = self.circle['y'] + 1
    self.box['r'] = 255
    self.box['g'] = 255
    self.box['b'] = 255
    self.box['mode'] = 'line'
end



function Space:isFilled()
    return self.claimedBy ~= 'none'
end



function Space:winningSlot()
    self.box['r'] = math.max((self.circle['r'] - 200), 0)
    self.box['g'] = math.max((self.circle['g'] - 200), 0)
    self.box['b'] = math.max((self.circle['b'] - 200), 0)
    self.box['mode'] = 'fill'
end



function Space:isFalling()
    return (self.circle['drop'] < self.circle['y'])
end



function Space:render()
    love.graphics.setColor(love.math.colorFromBytes(self.box['r'], self.box['g'], self.box['b'], 255))
    love.graphics.rectangle(self.box['mode'], self.box['x'], self.box['y'], self.box['size'], self.box['size'])

    love.graphics.setColor(love.math.colorFromBytes(self.circle['r'], self.circle['g'], self.circle['b'], 255))
    love.graphics.circle('fill', self.circle['x'], math.min(self.circle['drop'], self.circle['y']), self.circle['size'])

    if (self:isFilled() and self:isFalling()) then
        self.circle['drop'] = self.circle['drop'] + 50
    end
end
