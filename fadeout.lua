fadingOut = false
fadingIn = false
fadeout = 0

function fadeTo(newState)
    if fadingOut or fadingIn then return end
    fadingOut = true
    fadingIn = false
    fadeout = 0
    fadeState = newState
end

function fade_update(delta)
    if fadingOut then
        fadeout = fadeout + delta * fadeSpeed
        if fadeout >= fadeTime then
            fadingOut = false
            fadingIn = true
            changeGameState(fadeState)
        end
    elseif fadingIn then
        fadeout = fadeout - delta
        if fadeout <= 0 then
            fadingIn = false
        end
    end
end

function fade_draw()
    local g = util.map(fadeout, 0, fadeTime, 0, 1)
    love.graphics.setColor(0, 0, 0, g)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
end