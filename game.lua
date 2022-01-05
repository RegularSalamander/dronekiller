function game_load()
    --[[
        ints for controls
        positive means the amount of time it's been pressed
        negative means the amount of time since it was last pressed
        (0 means it was just released this frame)
        (1 means it was just pressed this frame)
    ]]
    controls = {
        left = 0,
        right = 0,
        up = 0,
        down = 0,
        z = 0,
        x = 0
    }
    cameraPos = {x=0, y=0}
    targetCameraY = 0

    bgPos = {x=0, y=0}
    bgHighlightX = 0

    cameraShake = 0

    objects = {}
    objects.player = { player:new() }
    objects.buildings = {}
    objects.drones = {}
    objects.debris = {}
    objects.explosions = {}

    objects.buildings[1] = building:new(0, 100, 100)
    lastX = 100 --worldGeneration
    lastY = 100

    backgroundHighlightCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
end

function game_update(delta)
    if not love.window.hasFocus() then return end
    delta = delta * 60
    delta = math.min(delta, 2)

    cameraShake = cameraShake - cameraShakeDeplete * delta
    cameraShake = math.max(0, cameraShake)

    cameraPos.x = math.max(cameraPos.x + cameraAutoScrollSpeed, objects.player[1].pos.x + cameraLookAhead + objects.player[1].vel.x * cameraSpeedLookAhead)
    targetCameraY = targetCameraY + util.sign((math.max(nowY, lastY)-screenHeight/2) - targetCameraY) * cameraYSpeed
    cameraPos.y = (objects.player[1].pos.y + targetCameraY)/2

    bgPos = {
        x=cameraPos.x * backgroundParallax,
        y=0
    }
    bgHighlightX = bgHighlightX + backgroundHighlightChange

    while objects.player[1].pos.x > lastX - screenWidth do
        generate()
    end

    objects.player[1]:control(delta)

    
    for k, v in pairs(objects) do
        local inactive = {}
        for i, _ in ipairs(objects[k]) do
            if objects[k][i].update then
                local continue = true
                for _ = 1, updatesPerFrame do
                    if continue and not objects[k][i]:update(delta / updatesPerFrame) then
                        continue = false
                        table.insert(inactive, i)
                    end
                end
            end
        end
        if #inactive then
            for i = #inactive, 1, -1 do
                table.remove(objects[k], inactive[i])
            end
        end
    end

    --update keys last
    for k, v in pairs(controls) do
        if v > 0 then controls[k] = v + delta
        else controls[k] = v - delta
        end
    end
end

function game_draw()
    love.graphics.setCanvas(backgroundHighlightCanvas)
    love.graphics.setBackgroundColor(0, 0, 0, 0)
    love.graphics.clear()
    love.graphics.draw(images.bg2)
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.draw(images.bgmask, bgHighlightX%screenWidth - screenWidth, bgPos.y)
    love.graphics.draw(images.bgmask, bgHighlightX%screenWidth, bgPos.y)
    love.graphics.setBlendMode("alpha")

    love.graphics.setCanvas(gameCanvas)

    love.graphics.setBackgroundColor(10/255, 10/255, 10/255)
    love.graphics.clear()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.bg1, bgPos.x%screenWidth - screenWidth, bgPos.y)
    love.graphics.draw(images.bg1, bgPos.x%screenWidth, bgPos.y)
    love.graphics.draw(backgroundHighlightCanvas, bgPos.x%screenWidth - screenWidth, bgPos.y)
    love.graphics.draw(backgroundHighlightCanvas, bgPos.x%screenWidth, bgPos.y)

    love.graphics.push()
    love.graphics.translate(math.floor(-cameraPos.x), math.floor(-cameraPos.y))
    love.graphics.translate(math.floor(screenWidth/2), math.floor(screenHeight/2))
    love.graphics.translate(math.floor(cameraShake*(math.random()-0.5)), math.floor(cameraShake*(math.random()-0.5)))

    if love.mouse.isDown(1) then
        local x, y = love.mouse.getPosition()
        x = x / (love.graphics.getWidth() / screenWidth)
        y = y / (love.graphics.getHeight() / screenHeight)
        x = x + cameraPos.x - screenWidth/2
        y = y + cameraPos.y - screenHeight/2
        spawnSmallExplosion(x, y)
    end
    if love.mouse.isDown(2) then
        local x, y = love.mouse.getPosition()
        x = x / (love.graphics.getWidth() / screenWidth)
        y = y / (love.graphics.getHeight() / screenHeight)
        x = x + cameraPos.x - screenWidth/2
        y = y + cameraPos.y - screenHeight/2
        spawnLargeExplosion(x, y)
    end

    for k, v in pairs(objects) do
        for i, _ in ipairs(objects[k]) do
            if objects[k][i].draw then
                objects[k][i]:draw()
            end
        end
    end
    objects.player[1]:draw() --draw on top

    love.graphics.pop()

    love.graphics.setCanvas()
end

function game_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 1 end
end

function game_keyreleased(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 0 end
    
end