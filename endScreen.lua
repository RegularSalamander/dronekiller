function endScreen_load()
    triggerRandomDialog(deadDialog, true)
    endScreenMenu = menu:new({
        {name="Quit to Menu", action=function() fadeTo("mainMenu") end},
        {name="Quit to Desktop", action=function() love.event.quit() end}
    })
end

function endScreen_update(delta)
    updateDialog(delta*60)
    sounds.musicLoop:setVolume(sounds.musicLoop:getVolume()-0.01*delta*60)
end

function endScreen_draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    endScreenMenu:draw()

    love.graphics.setColor(colorRed3)
    love.graphics.printf(
        "Points: " .. points .. "\n" ..
        "Drones Destroyed: " .. dronesKilled .. "\n" ..
        "Missiles Destroyed: " .. missilesKilled .. "\n" ..
        "Highest Combo: " .. highestCombo,
        0, 10, screenWidth, "center"
    )
end

function endScreen_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    endScreenMenu:control(scancode)
end