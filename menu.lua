--[[options is a table like the following:
    {
        {name="thing", action= function() doSomething() end}
    }
]]

menu = class:new()
function menu:init(options)
    self.options = options
    self.optionIndex = 1
end

function menu:control(scancode)
    if scancode == "up" or scancode == "w" then
        self.optionIndex = self.optionIndex - 1
        if self.optionIndex < 1 then self.optionIndex = #self.options end
    elseif scancode == "down" or scancode == "s" then
        self.optionIndex = self.optionIndex + 1
        if self.optionIndex > #self.options then self.optionIndex = 1 end
    elseif scancode == "z" or scancode == "return" or scancode == "space" then
        self.options[self.optionIndex].action()
    end
end

function menu:draw()
    local center = screenHeight / 2
    local top = center - menuItemSpacing * (#self.options - 1) / 2
    for i = 1, #self.options do
        if i == self.optionIndex then
            love.graphics.setColor(colorRed2)
        else
            love.graphics.setColor(colorGray1)
        end
        love.graphics.setFont(font)
        love.graphics.printf(self.options[i].name, 0, top + (i-1)*menuItemSpacing, screenWidth, "center")
    end
end