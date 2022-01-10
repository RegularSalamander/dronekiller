function pauseMenu_load()
    pauseMenu = menu:new({
        {name="Unpause", action=function() gameState = "game" nextGameState = "game" end},
        {name="Quit to Menu", action=function() fadeTo("mainMenu") end},
        {name="Quit to Desktop", action=function() love.event.quit() end}
    })
end

function pauseMenu_update(delta)
    if not sounds.musicStart:isPlaying() and not sounds.musicLoop:isPlaying() then
        sounds.musicLoop:play()
    end
end

function pauseMenu_draw()
    love.graphics.setCanvas(gameCanvas)
    game_draw()

    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    pauseMenu:draw()
end

function pauseMenu_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    pauseMenu:control(scancode)
    if scancode == "escape" then
        gameState = "game"
        nextGameState = "game"
    end
end