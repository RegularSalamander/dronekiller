missile = class:new()
function missile:init(x, y, ang)
    self.pos = {x=x, y=y}
    self.vel = {x=0, y=0}
    self.ang = ang or math.pi/4
    self.hurtBox = {x=x, y=y, w=3, h=3}
    self.hitBox = {x=x, y=y, w=3, h=3}
    self.active = true
end

function missile:update(delta, updateNum)
    self.vel.x = math.cos(self.ang) * missileSpeed * delta
    self.vel.y = math.sin(self.ang) * missileSpeed * delta
    self.pos.x = self.pos.x + self.vel.x
    self.pos.y = self.pos.y + self.vel.y

    self.hurtBox.x = self.pos.x
    self.hurtBox.y = self.pos.y
    self.hitBox.x = self.pos.x
    self.hitBox.y = self.pos.y

    if updateNum == 1 then
        spawnDirectionalExplosion(self.pos.x, self.pos.y, math.cos(self.ang)*missileExplosionSpeed, math.sin(self.ang)*missileExplosionSpeed)
    end

    if util.intersect(self.hitBox, objects.player[1].hurtBox) and (objects.player[1].state == "air" or objects.player[1].state == "ground") then
        if objects.player[1].timeSinceDashed > iframes then
            self:kill()
            fadeTo("dead")
            objects.player[1].alive = false
        end
    end

    for i, v in ipairs(objects.buildings) do
        if util.intersect(self.hurtBox, objects.buildings[i].colliderBox) then
            self:kill()
        end
    end

    return self.active and lastX - self.pos.x < purgeDistance and lastClimbY - self.pos.y < purgeDistance
end

function missile:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(images.missile, self.pos.x, self.pos.y, self.ang)
end

function missile:kill(dx, dy)
    cameraShake = cameraShakeLevel * 0.5
    self.active = false
    --table.insert(objects.debris, debris:new(self.pos.x, self.pos.y, dx, dy))
    --table.insert(objects.debris, debris:new(self.pos.x, self.pos.y, dx, dy))
    spawnLargeExplosion(self.pos.x, self.pos.y)
    spawnGiantExplosion(self.pos.x, self.pos.y)
end