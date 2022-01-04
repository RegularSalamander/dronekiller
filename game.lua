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

function game_load()
    objects = {}
    objects.player = { player:new() }
    objects.buildings = { 
        building:new(-10, 100, 100),
        building:new(-10+100+50, 100, 100)
    }
    objects.drones = {
        drone:new(115, 70),
        drone:new(115+25, 70-25),
        drone:new(115+75, 70-25)
    }
end

function game_update(delta)
    delta = delta * 60
    delta = math.min(delta, 2)

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

    for k, v in pairs(objects) do
        for i, _ in ipairs(objects[k]) do
            if objects[k][i].draw then
                objects[k][i]:draw()
            end
        end
    end 
end

function game_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 1 end
end

function game_keyreleased(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 0 end
    
end