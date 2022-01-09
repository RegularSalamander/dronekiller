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

    bgPos = {x=0, y=backgroundDefaultPosY}
    bgHighlightX = 0

    cameraShake = 0

    objects = {}
    objects.player = { player:new() }
    objects.player[1].pos.y = 94
    objects.buildings = {}
    objects.drones = {}
    objects.debris = {}
    objects.explosions = {}
    objects.comboNumbers = {}

    objects.buildings[1] = building:new(0, 100, 100)
    lastX = 100 --worldGeneration
    lastY = 100
    nowY = 100
    generationBag = {}
    atHeadquarters = false

    hasReachedMissileDistance = false

    backgroundHighlightCanvas = love.graphics.newCanvas(screenWidth, screenHeight)

    triggerRandomDialog(startDialog, true)
end

function game_update(delta)
    delta = delta * 60
    delta = math.min(delta, 2)

    cameraShake = cameraShake - cameraShakeDeplete * delta
    cameraShake = math.max(0, cameraShake)

    local prevCameraY = cameraPos.y

    local scrollSpeed = cameraAutoScrollSpeed
    if gameState == "tutorial" then scrollSpeed = 0 end
    if cameraPos.x < headquartersDistance then
        cameraPos.x = math.max(cameraPos.x + scrollSpeed, objects.player[1].pos.x + cameraLookAhead)
        targetCameraY = targetCameraY + util.sign((math.max(nowY, lastY)-screenHeight/2) - targetCameraY) * cameraYSpeed
        cameraPos.y = (objects.player[1].pos.y + targetCameraY)/2
    else
        cameraPos.y = math.min(cameraPos.y - scrollSpeed, objects.player[1].pos.y)
        --targetCameraX = headquartersDistance - cameraLookAhead
        cameraPos.x = math.max(cameraPos.x, objects.player[1].pos.x)
    end

    setBackgroundPos(delta)

    while objects.player[1].pos.x > lastX - screenWidth and
        not atHeadquarters and
        gameState ~= "tutorial" do --tutorial has preset world
        generate()
    end
    --lastX is really lastY when atHeadquarters
    while objects.player[1].pos.y < lastX + screenHeight and
        atHeadquarters do --tutorial has preset world
        generatePhaseThree()
    end

    objects.player[1]:control(delta)


    local slowMoDelta = delta
    if not objects.player[1].alive then slowMoDelta = delta * slowMoMultiplier end
    for k, v in pairs(objects) do
        local inactive = {}
        for i, _ in ipairs(objects[k]) do
            if objects[k][i].update then
                local continue = true
                for updateNum = 1, updatesPerFrame do
                    if continue and not objects[k][i]:update(slowMoDelta / updatesPerFrame, updateNum) then
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

    if not hasReachedMissileDistance and objects.player[1].pos.x > missileDistance - 500 then
        hasReachedMissileDistance = true
        triggerRandomDialog(phase2Dialog, true)
    end

    if gameState ~= "tutorial" and objects.player[1].pos.y < cameraPos.y-screenHeight/2 and objects.player[1].vel.y < dialogHighThreshhold and math.random() < dialogHighChance then
        triggerRandomDialog(highDialog)
    end

    if objects.player[1].pos.x < cameraPos.x - screenWidth/2 - offScreenGraceX then
        objects.player[1].pos.x = cameraPos.x - screenWidth/2  - offScreenGraceX
        if objects.player[1]:isColliding() then
            fadeTo("dead")
            objects.player[1].alive = false
        end
    end
    if objects.player[1].pos.y > cameraPos.y + screenHeight/2 + offScreenGraceY then
        fadeTo("dead")
        objects.player[1].alive = false
    end

    updateDialog(delta)

    --update keys last
    for k, v in pairs(controls) do
        if v > 0 then controls[k] = v + delta
        else controls[k] = v - delta
        end
    end
end

function game_draw()
    love.graphics.setCanvas(backgroundHighlightCanvas)
    drawBackgroundHighlight()

    love.graphics.setCanvas(gameCanvas)

    love.graphics.setBackgroundColor(colorGray4)
    love.graphics.clear()

    drawBackground()

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

    drawDialog()

    love.graphics.setCanvas()
end

function game_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 1 end
    if scancode == "escape" then changeGameState("pauseMenu") end
end

function game_keyreleased(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 0 end
    
end