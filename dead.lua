function dead_load()
    triggerRandomDialog(deadDialog, true)
end

function dead_update(delta)
    updateDialog(delta*60)
    if not inDialog() then
        fadeTo("game")
    end
end

function dead_draw()
    love.graphics.setCanvas(gameCanvas)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    drawDialog()
end