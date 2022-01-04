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

cameraShake = 0

function game_load()
    objects = {}
    objects.player = { player:new() }
    objects.buildings = { 
        building:new(0, 100, 100)
    }
    lastX = 100 --worldGeneration
    lastY = 100
    objects.drones = {}
end

function game_update(delta)
    delta = delta * 60
    delta = math.min(delta, 2)

    cameraShake = cameraShake - cameraShakeDeplete * delta
    cameraShake = math.max(0, cameraShake)

    while objects.player[1].pos.x > lastX - 200 do
        generate()
    end

    objects.player[1]:control(delta)

    for k, v in pairs(objects) do
        for i, _ in ipairs(objects[k]) do
            if objects[k][i].update then
                for _ = 1, 3 do
                    objects[k][i]:update(delta / 3)
                end
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
    love.graphics.clear()

    love.graphics.push()
    love.graphics.translate(-objects.player[1].pos.x, -objects.player[1].pos.y)
    love.graphics.translate(screenWidth/2, screenHeight/2)
    love.graphics.translate(cameraShake*(math.random()-0.5), cameraShake*(math.random()-0.5))

    for k, v in pairs(objects) do
        for i, _ in ipairs(objects[k]) do
            if objects[k][i].draw then
                objects[k][i]:draw()
            end
        end
    end

    love.graphics.pop()
end

function game_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 1 end
end

function game_keyreleased(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 0 end
    
end