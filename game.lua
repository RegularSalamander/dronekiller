--[[
    ints for controls
    positive means the amount of time it's been pressed
    negative means the amount of time since it was last pressed
    (0 means it was just released this frame)
    (1 means it was just pressed this frame)
]]
local controls = {
    left = 0,
    right = 0,
    up = 0,
    down = 0,
    z = 0,
    x = 0
}

function game_load()
    
end

function game_update()
    --do stuff before updating keys

    for key, value in pairs(controls) do
        if value > 0 then controls[key] = value + 1
        else controls[key] = value - 1
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