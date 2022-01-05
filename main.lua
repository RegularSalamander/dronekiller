require "class"
util = require "salamanderUtils"
require "variables"

require "player"
require "building"
require "drone"
require "debris"
require "explosion"

require "game"
require "worldGeneration"

gameState = ""
scale = 4

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(screenWidth*scale, screenHeight*scale)

    gameCanvas = love.graphics.newCanvas(screenWidth, screenHeight)

    changeGameState("game")
end

function love.update(delta)
    if _G[gameState .. "_update"] then
        _G[gameState .. "_update"](delta)
    end
end

function love.draw()
    love.graphics.setCanvas(gameCanvas)

    if _G[gameState .. "_draw"] then
        _G[gameState .. "_draw"]()
    end

    love.graphics.setCanvas()

    local w, h = love.graphics.getDimensions()
    local scl = math.floor(math.min(w/screenWidth, h/screenHeight))*1
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, w/2, h/2, 0, scl, scl, screenWidth/2, screenHeight/2)
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