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
require "transceiver"
require "menu"
require "mainMenu"
require "pauseMenu"
require "optionMenu"
require "endScreen"
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

function love.load()
    math.randomseed(os.time())
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.window.setMode(screenWidth*optionScale, screenHeight*optionScale, { vsync = true, msaa = 0, highdpi = true })
    love.window.setTitle("DRONEKILLER")

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
    images.sign = love.graphics.newImage("assets/sign.png")
    images.transceiver = love.graphics.newImage("assets/transceiver.png")
    images.transceiverDead = love.graphics.newImage("assets/transceiverDead.png")
    images.logo1 = love.graphics.newImage("assets/logo1.png")
    images.logo2 = love.graphics.newImage("assets/logo2.png")

    sounds = {}
    sounds.musicStart = love.audio.newSource("assets/DRONEKILLER_start.mp3", "stream")
    sounds.musicLoop = love.audio.newSource("assets/DRONEKILLER_loop.mp3", "stream")
    sounds.musicLoop:setLooping(true)
    sounds.explosion1 = love.audio.newSource("assets/explosion1.wav", "static")
    sounds.explosion2 = love.audio.newSource("assets/explosion2.wav", "static")
    sounds.explosion3 = love.audio.newSource("assets/explosion3.wav", "static")
    sounds.explosion4 = love.audio.newSource("assets/explosion4.wav", "static")
    sounds.bigExplosion1 = love.audio.newSource("assets/bigExplosion1.wav", "static")
    sounds.bigExplosion2 = love.audio.newSource("assets/bigExplosion2.wav", "static")
    sounds.rumble = love.audio.newSource("assets/rumble.wav", "static")
    sounds.rumble:setLooping(true)
    sounds.missile = love.audio.newSource("assets/missile.wav", "static")
    sounds.missile:setLooping(true)
    sounds.dialog = love.audio.newSource("assets/dialog.wav", "static")

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
    if gameState ~= "pauseMenu" and nextGameState ~= "pauseMenu" then
        for k, v in pairs(sounds) do
            sounds[k]:stop()
        end
    end
    gameState = nextGameState
    if _G[gameState .. "_load"] then
        _G[gameState .. "_load"]()
    end
end