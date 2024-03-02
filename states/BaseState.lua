--[[
    GD50

    -- BaseState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Modified by B. Cobb
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter(enterParams) end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
function BaseState:mousepressed(x, y, button) end
function BaseState:keypressed(key) end
function BaseState:resize(w, h) end