optionFullscreen = false
optionFullScreenScale = 0
optionScale = 4

function optionMenu_load()
    optionMenu = menu:new({
        {name="Toggle Fullscreen", action=function()
            optionFullScreenScale = math.min(love.graphics.getWidth()/screenWidth, love.graphics.getHeight()/screenHeight)
            optionFullscreen = not optionFullscreen
            love.window.setFullscreen(optionFullscreen)
        end},
        {name="Increase Window Size", action=function()
            optionScale = optionScale + 1
            optionFullscreen = false
            love.window.setMode(screenWidth*optionScale, screenHeight*optionScale, { vsync = true, msaa = 0, highdpi = true })
        end},
        {name="Decrease Window Size", action=function()
            optionScale = optionScale - 1
            optionScale = math.max(1, optionScale)
            optionFullscreen = false
            love.window.setMode(screenWidth*optionScale, screenHeight*optionScale, { vsync = true, msaa = 0, highdpi = true })
        end},
        {name="Back", action=function() fadeTo("mainMenu") end}
    })
end

function optionMenu_draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    optionMenu:draw()
end

function optionMenu_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    optionMenu:control(scancode)
end