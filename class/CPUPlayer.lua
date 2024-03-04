CPUPlayer = Class{}

function CPUPlayer:init(difficulty)
    self.difficulty = difficulty
    self.timer = 0

end



function CPUPlayer:nextMove()
    self:resetTimer()
    if (self.difficulty == 'easy') then
        return self:easyMove()
    elseif (self.difficulty == 'medium') then
        return self:easyMove()
    elseif (self.difficulty == 'hard') then
        return self:easyMove()
    end
end



function CPUPlayer:easyMove()
    return math.random(1, 7)
end



function CPUPlayer:timeToMove(dt)
    self.timer = self.timer + dt
    return (self.timer >= 1.3)
end



function CPUPlayer:resetTimer()
    self.timer = 0
end



function CPUPlayer:isActive()
    return self.difficulty
end


--[[
CPU player should:
    Have its own timer to make the wait feel natural
    Return column numbers for moves based on its difficulty settings
    Does not need render or draw functions, just an initializer, a field to store its difficulty, and some algorithm functins

    EASY mode will just return a random number
    MEDIUM mode will perform a minimax but will not account for number of moves
    HARD mode will perform the minimax AND will account for number of moves in its calculus

]]