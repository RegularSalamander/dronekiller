lastX = 0
lastY = 0
lastClimbY = 0
nowY = 0
generationBag = {}

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
        table.insert(objects.drones, drone:new(
            x + (v%width)*cloudDistance + (math.random()-0.5)*cloudDistance*0.5,
            y + math.floor(v/width)*cloudDistance + (math.random()-0.5)*cloudDistance*0.5
        ))
    end
end

function generateStrikeLeft(x, y, w, h, a)
    for i = 1, a do
        table.insert(objects.drones, missile:new(util.randRange(x, x+w), util.randRange(y, y+h), math.pi*3/4))
    end
end

function generateStrikeRight(x, y, w, h, a)
    for i = 1, a do
        table.insert(objects.drones, missile:new(util.randRange(x, x+w), util.randRange(y, y+h), math.pi*1/4))
    end
end

function generate(override)
    nowY = lastY
    local options = 2
    if lastX >= droneDistance then
        options = 8
    end
    if lastX >= missileDistance then
        options = 12
    end

    local r --choice
    local isDone
    repeat
        r = util.randInt(1, options)
        isDone = false
        for i, v in ipairs(generationBag) do
            if v == r then isDone = true end
        end
    until not isDone
    io.write(r .. "\n")
    table.insert(generationBag, r)
    if #generationBag >= options then
        io.write(lastX .. "\n")
        generationBag = {}
    end

    if r == 1 then
        --small gap + thin building
        table.insert(objects.buildings, building:new(lastX + 50, lastY, 100))
        lastX = lastX + 50 + 100
        lastY = lastY
    elseif r == 2 then
        --medium gap + thick building + 3x2x2
        table.insert(objects.buildings, building:new(lastX + 100, lastY, 200))
        lastX = lastX + 100 + 200
        lastY = lastY
    elseif r == 3 then
        --small gap + thin building
        table.insert(objects.buildings, building:new(lastX + 50, lastY, 100))
        generateCloud(lastX+75, lastY - cloudDistance*1, 2, 1, 2)
        lastX = lastX + 50 + 100
        lastY = lastY
    elseif r == 4 then
        --medium gap + thick building + 3x2x2
        table.insert(objects.buildings, building:new(lastX + 100, lastY, 200))
        generateCloud(lastX+175, lastY - cloudDistance*2, 3, 2, 2)
        lastX = lastX + 100 + 200
        lastY = lastY
    elseif r == 5 then
        --medium gap + thin building, cloud in gap
        table.insert(objects.buildings, building:new(lastX + 100, lastY, 100))
        generateCloud(lastX+50, lastY - cloudDistance*2, 3, 2, 3)
        lastX = lastX + 100+100
        lastY = lastY
    elseif r == 6 then
        --go up with a cloud
        table.insert(objects.buildings, building:new(lastX + 150, lastY - 100, 200))
        generateCloud(lastX+50, lastY - cloudDistance*1.5, 2, 2, 3)
        lastX = lastX + 150 + 200
        lastY = lastY - 100
    elseif r == 7 then
        --go down with a cloud
        table.insert(objects.buildings, building:new(lastX + 150, lastY + 100, 200))
        generateCloud(lastX+50, lastY + cloudDistance*1.5, 2, 2, 3)
        lastX = lastX + 150 + 200
        lastY = lastY + 100
    elseif r == 8 then
        --huge gap with huge cloud
        table.insert(objects.buildings, building:new(lastX + 350, lastY, 200))
        generateCloud(lastX+50, lastY-cloudDistance*2, math.floor(340/cloudDistance), 3, 13)
        lastX = lastX + 350 + 200
        lastY = lastY
    elseif r <= 10 then
        --medium gap + thick building + target drone
        table.insert(objects.buildings, building:new(lastX + 100, lastY, 200))
        table.insert(objects.drones, targetMissile:new(lastX+100, lastY-50))
        lastX = lastX + 100 + 200
        lastY = lastY
    elseif r <= 12 then
        --medium gap + giant building + air strike
        table.insert(objects.buildings, building:new(lastX + 100, lastY, 400))
        local offset = 800
        generateStrikeLeft(lastX+100+offset, lastY-offset, 300, 200, 10)
        lastX = lastX + 100 + 400
        lastY = lastY
    end

    if lastX >= headquartersDistance then
        atHeadquarters = true
        table.insert(objects.buildings, building:new(lastX + 100, lastY-crystalHeight, 400, crystalHeight+500))
        lastX = lastX + 100
        generationBag = {}
        lastClimbY = lastY
        triggerRandomDialog(phase3Dialog, true)
    end
end

function generatePhaseThree(override)
    local r --choice
    local options = 4

    local isDone
    repeat
        r = util.randInt(1, options)
        isDone = false
        for i, v in ipairs(generationBag) do
            if v == r then isDone = true end
        end
    until not isDone
    table.insert(generationBag, r)
    if #generationBag >= options then
        generationBag = {}
    end

    if r == 1 then
        --5 cloud
        generateCloud(lastX - 100, lastClimbY - 200, 2, 3, 5)
        lastClimbY = lastClimbY - 200
    elseif r == 2 then
        --nothing
        lastClimbY = lastClimbY - 100
    elseif r == 3 then
        --sign
        table.insert(objects.buildings, building:new(lastX - 5, lastClimbY-60, 5, 3))
        table.insert(objects.buildings, building:new(lastX - 5, lastClimbY-70, 5, 3))
        table.insert(objects.buildings, building:new(lastX - 43, lastClimbY-72, 40, 17))
        generateCloud(lastX-100, lastClimbY-100, 1, 3, 2)
        lastClimbY = lastClimbY - 150
    elseif r == 4 then
        --medium gap + giant building + air strike
        local offset = 800
        generateStrikeRight(lastX-offset, lastClimbY-offset, 300, 200, 10)
        lastClimbY = lastClimbY - 150
    end
end