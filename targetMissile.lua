targetMissile = missile:new()
function targetMissile:update(delta, updateNum)
    self.vel.x = math.cos(self.ang) * missileSpeed * delta
    self.vel.y = math.sin(self.ang) * missileSpeed * delta
    self.pos.x = self.pos.x + self.vel.x
    self.pos.y = self.pos.y + self.vel.y

    self.hurtBox.x = self.pos.x
    self.hurtBox.y = self.pos.y
    self.hitBox.x = self.pos.x-1
    self.hitBox.y = self.pos.y-1

    if updateNum == 1 then
        spawnDirectionalExplosion(self.pos.x, self.pos.y, math.cos(self.ang)*missileExplosionSpeed, math.sin(self.ang)*missileExplosionSpeed)
    end

    local allowedToTurn = true
    for i, v in ipairs(objects.drones) do
        if objects.drones[i].ang  and objects.drones[i].pos.x ~= self.pos.x then 
            allowedToTurn = false
        end
    end
    if allowedToTurn then
        self.ang = self.ang%(math.pi*2)
        local targetAng = math.atan2(objects.player[1].pos.y - self.pos.y, objects.player[1].pos.x - self.pos.x)
        while self.ang < 0 do self.ang = self.ang + math.pi*2 end
        if math.abs(self.ang - targetAng) > math.abs(self.ang - targetAng - math.pi*2) then
            targetAng = targetAng + math.pi*2
        end
        if math.abs(self.ang - targetAng) > math.abs(self.ang - targetAng + math.pi*2) then
            targetAng = targetAng + math.pi*2
        end
        self.ang = self.ang + util.sign(targetAng - self.ang) * missileTurnSpeed * delta
    end

    if util.intersect(self.hitBox, objects.player[1].hurtBox) and (objects.player[1].state == "air" or objects.player[1].state == "ground") then
        self:kill()
        fadeTo("dead")
        objects.player[1].alive = false
    end

    for i, v in ipairs(objects.buildings) do
        if util.intersect(self.hurtBox, objects.buildings[i].colliderBox) then
            self:kill()
        end
    end

    return self.active and lastX - self.pos.x < purgeDistance and lastClimbY - self.pos.y < purgeDistance
end