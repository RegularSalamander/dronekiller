function setBackgroundPos(cameraYChange)
    bgPos = {
        x=cameraPos.x * backgroundParallax,
        y=bgPos.y + cameraYChange * backgroundParallax
    }
    bgHighlightX = bgHighlightX + backgroundHighlightChange
    bgPos.y = bgPos.y + util.sign(backgroundDefaultPosY - bgPos.y) * backgroundYParallaxReturnSpeed

    io.write(bgPos.y)
    io.write('\n')
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