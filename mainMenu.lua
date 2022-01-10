function mainMenu_load()
    mainMenu = menu:new({
        {name="Start", action=function() fadeTo("game") end},
        {name="Tutorial", action=function() fadeTo("tutorial") end},
        {name="Options", action=function() fadeTo("optionMenu") end},
        {name="Quit", action=function() love.event.quit() end}
    })
    
    bgPos = {x=0, y=backgroundDefaultPosY}
    bgHighlightX = 0
    backgroundHighlightCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
    logoCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
    cameraPos = {x=0, y=0}
end

function mainMenu_update(delta)
    setBackgroundPos(delta*60*2)
end

function mainMenu_draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(0, 0, 0, 1)
    
    love.graphics.setCanvas(backgroundHighlightCanvas)
    drawBackgroundHighlight()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setBackgroundColor(colorGray4)
    love.graphics.clear()
    drawBackground()

    love.graphics.setCanvas(logoCanvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.logo2, 63, 20)
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(images.bgmask, bgHighlightX%screenWidth - screenWidth, 0)
    love.graphics.draw(images.bgmask, bgHighlightX%screenWidth, 0)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setCanvas(gameCanvas)
    love.graphics.draw(images.logo1, 63, 20)
    love.graphics.draw(logoCanvas)

    mainMenu:draw()
end

function mainMenu_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    mainMenu:control(scancode)
end