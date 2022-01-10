transceiver = class:new()
function transceiver:init(x, y)
    self.pos = {x=x, y=y}
    self.hurtBox = {x=x, y=y, w=3, h=2}
    self.active = true
end

function transceiver:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.transceiver, self.pos.x - 4, self.pos.y)
end

function transceiver:kill(dx, dy)
    transceiverHealth = transceiverHealth - 1
end