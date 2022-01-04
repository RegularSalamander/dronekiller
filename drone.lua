drone = class:new()
function drone:init(x, y)
    self.pos = {x=x, y=y}
    self.usualPos = {x=x, y=y}
    self.vel = {x=0, y=0}
    self.timeOffset = math.random()*60
    self.hurtBox = {x=x, y=y, w=3, h=2}
    self.hitBox = {x=x, y=y, w=3, h=2}
    self.active = true
end

function drone:update(delta)
    self.timeOffset = self.timeOffset + delta
    self.pos.y = math.sin(self.timeOffset*0.05)*3+self.usualPos.y
    self.pos.y = self.pos.y + math.sin(self.timeOffset*0.01)*7
    self.pos.x = math.sin(self.timeOffset*0.008+10)*7+self.usualPos.x

    self.hurtBox.x = self.pos.x
    self.hurtBox.y = self.pos.y
    self.hitBox.x = self.pos.x
    self.hitBox.y = self.pos.y

    return self.active
end

function drone:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 3, 2)
end

function drone:kill(dx, dy)
    self.active = false
    table.insert(objects.debris, debris:new(self.pos.x, self.pos.y, dx, dy))
    table.insert(objects.debris, debris:new(self.pos.x, self.pos.y, dx, dy))
end