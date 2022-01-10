drone = class:new()
function drone:init(x, y)
    self.pos = {x=x, y=y}
    self.usualPos = {x=x, y=y}
    self.timeOffset = math.random()*60
    self.hurtBox = {x=x, y=y, w=3, h=2}
    self.active = true
    self.falling = false
    self.fallingSpeed = 0
    self.fallingAng = 0
    self.fallingAngSpeed = 0
end

function drone:update(delta)
    self.timeOffset = self.timeOffset + delta
    self.pos.y = math.sin(self.timeOffset*0.05)*3+self.usualPos.y
    self.pos.y = self.pos.y + math.sin(self.timeOffset*0.01)*7
    self.pos.x = math.sin(self.timeOffset*0.008+10)*7+self.usualPos.x

    self.hurtBox.x = self.pos.x
    self.hurtBox.y = self.pos.y

    if self.falling then
        self.usualPos.y = self.usualPos.y + self.fallingSpeed * delta
        self.fallingSpeed = self.fallingSpeed + gravity * delta
        self.fallingAng = self.fallingAng + self.fallingAngSpeed
        for i, v in ipairs(objects.buildings) do
            if util.intersect(self.hurtBox, objects.buildings[i].colliderBox) then
                self:kill(0, 0)
            end
        end
    end

    return self.active and lastX - self.pos.x < purgeDistance and lastClimbY - self.pos.y < purgeDistance
end

function drone:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.drone, self.pos.x, self.pos.y, self.fallingAng)
end

function drone:fall()
    self.falling = true
    self.fallingAngSpeed = util.randRange(-0.02, 0.02)
end

function drone:kill(dx, dy)
    self.active = false
    table.insert(objects.debris, debris:new(self.pos.x, self.pos.y, dx, dy))
    table.insert(objects.debris, debris:new(self.pos.x, self.pos.y, dx, dy))
    spawnLargeExplosion(self.pos.x, self.pos.y)
end