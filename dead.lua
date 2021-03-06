function dead_load()
    triggerRandomDialog(deadDialog, true)
    deadMenu = menu:new({
        {name="Retry", action=function() fadeTo("game") end},
        {name="Quit to Menu", action=function() fadeTo("mainMenu") end},
        {name="Quit to Desktop", action=function() love.event.quit() end}
    })
end

function dead_update(delta)
    updateDialog(delta*60)
    sounds.musicLoop:setVolume(sounds.musicLoop:getVolume()-0.01*delta*60)
end

function dead_draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    drawDialog()
    deadMenu:draw()

    love.graphics.setColor(colorRed3)
    love.graphics.setFont(comboFont)
    love.graphics.print(points, 2, screenHeight-13)
end

function dead_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    deadMenu:control(scancode)
end