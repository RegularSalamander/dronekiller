require "class"
util = require "util"

require "game"

gameState = ""

function love.load()
    changeGameState("game")
end

function love.update()
    if _G[gameState .. "_update"] then
        _G[gameState .. "_update"]()
    end
end

function love.draw()
    if _G[gameState .. "_draw"] then
        _G[gameState .. "_draw"]()
    end
end

function love.keypressed(key, unicode)
	if _G[gamestate .. "_keypressed"] then
		_G[gamestate .. "_keypressed"](key, unicode)
	end
end

function love.keyreleased(key, unicode)
	if _G[gamestate .. "_keyreleased"] then
		_G[gamestate .. "_keyreleased"](key, unicode)
	end
end

function changeGameState(newState)
    gameState = newState
    if _G[gameState .. "_load"] then
        _G[gameState .. "_load"]()
    end
end