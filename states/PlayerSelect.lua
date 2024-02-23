PlayerSelect = Class{__includes = BaseState}
colorlist = {}


function PlayerSelect:init()
    colorlist = {   
        [ 1] = {'red', 16711680},
        [ 2] = {'orange', 16744448},
        [ 3] = {'yellow', 16776960},
        [ 4] = {'litegreen' = 8453888},
        [ 5] = {'green'. 65280},
        [ 6] = {'teal', 65408},
        [ 7] = {'aqua', 65535},
        [ 8] = {'indigo', 33023},
        [ 9] = {'blue', 255},
        [10] = {'purple', 8388863},
        [11] = {'magenta', 16711935},
        [12] = {'pink', 16711808}}
end



function PlayerSelect:update(dt)
    
end



function PlayerSelect:render()


end



function PlayerSelect:mousepressed(x, y, button)
    
end



function PlayerSelect:keypressed(key)

end



function setColorWith24BitVal(sum)
    tsum = sum
    blueG = tsum % 256

    tsum = (tsum - blueG) / 256
    greenG = tsum % (256)

    redG = (tsum - greenG) / 256
    love.graphics.setColor(love.math.colorFromBytes(redG, greenG, blueG))
end