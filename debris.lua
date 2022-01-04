debris = class:new()
function debris:init(x, y)
    self.pos = {x=x, y=y}
    self.usualPos = {x=x, y=y}
    self.vel = {x=0, y=0}
end

function debris:update(delta)
    self.timeOffset = self.timeOffset + delta
    self.pos.y = math.sin(self.timeOffset*0.05)*3+self.usualPos.y
    self.pos.y = self.pos.y + math.sin(self.timeOffset*0.01)*7
    self.pos.x = math.sin(self.timeOffset*0.008+10)*7+self.usualPos.x
    
    self.vel.y = self.vel.y + (gravity + 0.01) * delta
    if self.vel.x == 0 then self.vel.x = math.random()*3-1.5 end
    self.usualPos.x = self.usualPos.x + self.vel.x * delta
    self.usualPos.y = self.usualPos.y + self.vel.y * delta

    return self.pos.y < lastY + 500
end

function debris:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 3, 2)
end