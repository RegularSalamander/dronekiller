drone = class:new()
function drone:init(x, y)
    self.pos = {x = x, y = y}
    self.timeOffset = math.random()*10
    self.hurtBox = {x=x, y=y, w=3, h=2}
    self.hitBox = {x=x, y=y, w=3, h=2}
    self.alive = true
end

function drone:update(delta)
    self.timeOffset = self.timeOffset + delta
end

function drone:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.hurtBox.x, self.hurtBox.y, self.hurtBox.w, self.hurtBox.h)
end