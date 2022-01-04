debris = class:new()
function debris:init(x, y, dx, dy)
    self.pos = {x=x, y=y}
    self.vel = {
        x = dx + util.randRange(-1.5, 1.5),
        y = dy + util.randRange(-1.5, 1.5)
    }
end

function debris:update(delta)
    self.vel.y = self.vel.y + (gravity + 0.01) * delta
    self.pos.x = self.pos.x + self.vel.x * delta
    self.pos.y = self.pos.y + self.vel.y * delta

    return self.pos.y < lastY + 500
end

function debris:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 3, 2)
end