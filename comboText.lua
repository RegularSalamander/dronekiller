comboText = class:new()
function comboText:init(x, y, num)
    self.pos = {x=x, y=y}
    self.num = num
    self.timeToLive = 60
end

function comboText:update(delta)
    self.timeToLive = self.timeToLive - delta

    self.pos.y = self.pos.y - delta
    return self.timeToLive >= 0
end

function comboText:draw()
    love.graphics.setFont(comboFont)
    love.graphics.setColor(colorBlue1)
    love.graphics.print("x" .. self.num, self.pos.x, self.pos.y)
end