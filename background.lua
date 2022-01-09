function setBackgroundPos(delta)
    bgPos = {
        x=cameraPos.x * backgroundParallax,
        y=cameraPos.y * backgroundParallax+40,
    }
    bgHighlightX = bgHighlightX + backgroundHighlightChange * delta
end

function drawBackgroundHighlight()
    love.graphics.setBackgroundColor(0, 0, 0, 0)
    love.graphics.clear()
    love.graphics.draw(images.bg2)
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(images.bgmask, bgHighlightX%screenWidth - screenWidth, 0)
    love.graphics.draw(images.bgmask, bgHighlightX%screenWidth, 0)
    love.graphics.setBlendMode("alpha")
end

function drawBackground()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.bg1, bgPos.x%screenWidth - screenWidth, bgPos.y)
    love.graphics.draw(images.bg1, bgPos.x%screenWidth, bgPos.y)
    love.graphics.draw(backgroundHighlightCanvas, bgPos.x%screenWidth - screenWidth, bgPos.y)
    love.graphics.draw(backgroundHighlightCanvas, bgPos.x%screenWidth, bgPos.y)
end