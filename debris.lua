debris = class:new()
function debris:init(x, y, dx, dy)
    self.pos = {x=x, y=y}
    self.vel = {
        x = dx + util.randRange(-1 * debrisMovement, debrisMovement),
        y = dy + util.randRange(-1 * debrisMovement, debrisMovement)
    }
    self.timeToLive = 15 + math.random()*5
end

function debris:update(delta)
    self.timeToLive = self.timeToLive - delta

    if self.timeToLive <= 0 then
        spawnSmallExplosion(self.pos.x, self.pos.y)
    end

    self.vel.y = self.vel.y + gravity * delta
    self.pos.x = self.pos.x + self.vel.x * delta
    self.pos.y = self.pos.y + self.vel.y * delta

    return self.timeToLive > 0
end

function debris:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 3, 2)
end