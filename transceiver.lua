transceiver = class:new()
function transceiver:init(x, y)
    self.pos = {x=x, y=y}
    self.health = 20
    self.hurtBox = {x=x, y=y, w=3, h=2}
    self.active = true
end

function transceiver:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.drone, self.pos.x, self.pos.y)
end

function transceiver:kill(dx, dy)
    self.health = self.health - 1
    if self.health <= 0 then
        --end game
    end
end