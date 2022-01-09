local currentDialog = {}
local dialogIndex = 1
local dialogLetter = 0
local dialogPortrait = 0

local dialogCanvas
local dialogScroll = 0

function inDialog()
    return #currentDialog > 0
end

function setDialog(table, forced)
    forced = forced or false
    if inDialog() and not forced then return end
    currentDialog = table
    dialogIndex = 1
    dialogLetter = 0
end

function updateDialog(delta)
    if not inDialog() then return end
    dialogLetter = dialogLetter + dialogLetterSpeed * delta
    dialogScroll = dialogScroll + dialogScrollSpeed * delta
    if dialogLetter > string.len(currentDialog[dialogIndex+1])+40 then
        dialogLetter = 0
        dialogIndex = dialogIndex + 2
        if not currentDialog[dialogIndex] then
            currentDialog = {}
        end
    end
end

function drawDialog()
    if not inDialog() then return end
    dialogCanvas = dialogCanvas or love.graphics.newCanvas(308, 32)

    love.graphics.setColor(colorBlue4)
    --love.graphics.rectangle("fill", 5, 5, 310, 34)
    
    love.graphics.setCanvas(dialogCanvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.textbox, dialogScroll%308 - 308, 0)
    love.graphics.draw(images.textbox, dialogScroll%308, 0)
    love.graphics.setCanvas(gameCanvas)
    love.graphics.draw(dialogCanvas, 6, 6)

    local portraitShift = 0
    local onRight = false
    local colorChoice
    if currentDialog[dialogIndex] == "transmute" then
        portraitShift = 0
        colorChoice = colorPurple1
    elseif currentDialog[dialogIndex] == "hero" then
        portraitShift = 32
        colorChoice = colorBlue1
    elseif currentDialog[dialogIndex] == "ceo" then
        portraitShift = 64
        colorChoice = colorRed3
        onRight = true
    end

    love.graphics.setFont(font)
    
    if not onRight then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            images.portraits,
            love.graphics.newQuad(portraitShift, 0, 32, 32, 32*3, 32),
            6,
            6
        )
        love.graphics.setColor(colorChoice)
        love.graphics.print(string.sub(currentDialog[dialogIndex+1], 1, dialogLetter), 40, 4)
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            images.portraits,
            love.graphics.newQuad(portraitShift, 0, 32, 32, 32*3, 32),
            282,
            6
        )
        love.graphics.setColor(colorChoice)
        love.graphics.print(string.sub(currentDialog[dialogIndex+1], 1, dialogLetter), 40-32, 4)
    end
end

function triggerRandomDialog(list, forced)
    setDialog(list[util.randInt(1, #list)], forced)
end