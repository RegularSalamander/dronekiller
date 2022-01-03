require "class"
util = require "salamanderUtils"

require "variables"
require "game"
require "player"

gameState = ""

function love.load()
    changeGameState("game")
end

function love.update(delta)
    if _G[gameState .. "_update"] then
        _G[gameState .. "_update"](delta)
    end
end

function love.draw()
    if _G[gameState .. "_draw"] then
        _G[gameState .. "_draw"]()
    end
end

function love.keypressed(key, scancode, isrepeat)
	if _G[gameState .. "_keypressed"] then
		_G[gameState .. "_keypressed"](key, scancode, isrepeat)
	end
end

function love.keyreleased(key, scancode, isrepeat)
	if _G[gameState .. "_keyreleased"] then
		_G[gameState .. "_keyreleased"](key, scancode, isrepeat)
	end
end

function changeGameState(newState)
    gameState = newState
    if _G[gameState .. "_load"] then
        _G[gameState .. "_load"]()
    end
end