require "class"
util = require "salamanderUtils"

require "variables"
require "player"
require "playerdraw"
require "building"
require "drone"
require "missile"
require "targetMissile"
require "debris"
require "explosion"
require "comboText"
require "menu"
require "mainMenu"
require "pauseMenu"
require "worldGeneration"
require "background"
require "dialog"
require "randomDialog"
require "fadeout"
require "game"
require "dead"
require "tutorial"

gameState = ""
nextGameState = ""
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
    images.target = love.graphics.newImage("assets/target.png")
    images.portraits = love.graphics.newImage("assets/portraits.png")

    font = love.graphics.newFont("assets/fancySalamander.ttf", 16)
    font:setFilter("nearest", "nearest")
    comboFont = love.graphics.newFont("assets/comboFont.ttf", 16)
    comboFont:setFilter("nearest", "nearest")

    gameCanvas = love.graphics.newCanvas(screenWidth, screenHeight)

    changeGameState("mainMenu")
end

function love.update(delta)
    if not love.window.hasFocus() then return end
    
    if _G[gameState .. "_update"] then
        _G[gameState .. "_update"](delta)
    end
    fade_update(delta*60)

    setGameState("")
end

function love.draw()
    if _G[gameState .. "_draw"] then
        _G[gameState .. "_draw"]()
    end
    love.graphics.setCanvas(gameCanvas)
    fade_draw()

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
    nextGameState = newState
end

function setGameState()
    if gameState == nextGameState then return end
    gameState = nextGameState
    if _G[gameState .. "_load"] then
        _G[gameState .. "_load"]()
    end
end