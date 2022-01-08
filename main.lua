require "class"
util = require "salamanderUtils"
require "variables"

require "player"
require "playerdraw"
require "building"
require "worldGeneration"
require "drone"
require "missile"
require "targetMissile"
require "debris"
require "explosion"
require "background"
require "dialog"
require "randomDialog"

require "game"
require "tutorial"

gameState = ""
scale = 5

function love.load()
    math.randomseed(os.time())
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(screenWidth*scale, screenHeight*scale, { vsync = true, msaa = 0, highdpi = true })

    images = {}
    images.player = love.graphics.newImage("assets/playerrun.png")
    images.drone = love.graphics.newImage("assets/drone.png")
    images.missile = love.graphics.newImage("assets/missile.png")
    images.bg1 = love.graphics.newImage("assets/background1.png")
    images.bg2 = love.graphics.newImage("assets/background2.png")
    images.bgmask = love.graphics.newImage("assets/backgroundmask.png")
    images.textbox = love.graphics.newImage("assets/textbox.png")
    images.portraits = love.graphics.newImage("assets/portraits.png")

    font = love.graphics.newFont("assets/fancySalamander.ttf", 16)
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

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