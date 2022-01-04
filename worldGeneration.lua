lastX = 0
lastY = 0

--call with the x of the edge of the last placed building, and the y of that building
function generate()
    local options = 4
    local r = util.randInt(1, options)
    if r == 1 then
        --small gap + thin building
        table.insert(objects.buildings, building:new(lastX + 50, lastY, 100))
        lastX = lastX + 50 + 100
        lastY = lastY
    elseif r == 2 then
        --medium gap + thick building + 3x2x2
        table.insert(objects.buildings, building:new(lastX + 100, lastY, 200))
        generateCloud(lastX+175, lastY - cloudDistance*2, 3, 2, 2)
        lastX = lastX + 100 + 200
        lastY = lastY
    elseif r == 3 then
        --medium gap + thin building, cloud in gap
        table.insert(objects.buildings, building:new(lastX + 100, lastY, 100))
        generateCloud(lastX+50, lastY - cloudDistance*2, 3, 2, 3)
        lastX = lastX + 100+100
        lastY = lastY
    elseif r == 4 then
        --go up with a cloud
        table.insert(objects.buildings, building:new(lastX + 200, lastY - 100, 200))
        generateCloud(lastX+50, lastY - cloudDistance*2, 2, 2, 3)
        lastX = lastX + 200 + 200
        lastY = lastY - 100
    end
end

function generateCloud(x, y, width, height, number)
    local choices = {}
    while #choices < number do
        local newChoice = util.randInt(1, width*height) - 1
        local isChosen = false
        for i, v in ipairs(choices) do
            if v == newChoice then isChosen = true end
        end
        if not isChosen then
            table.insert(choices, newChoice)
        end
    end

    for i, v in ipairs(choices) do
        table.insert(objects.drones, drone:new(x + (v%width)*cloudDistance, y + math.floor(v/width)*cloudDistance))
    end
end