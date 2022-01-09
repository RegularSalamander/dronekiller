function mainMenu_load()
    mainMenu = menu:new({
        {name="Start", action=function() fadeTo("game") end},
        {name="Tutorial", action=function() fadeTo("tutorial") end},
        {name="Quit", action=function() love.event.quit() end}
    })
end

function mainMenu_update(delta)

end

function mainMenu_draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    mainMenu:draw()
end

function mainMenu_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    mainMenu:control(scancode)
end