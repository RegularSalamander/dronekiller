player = class:new()
function player:init()
    self.pos = {x=0, y=0}
    self.vel = {x=0, y=0}
    
    self.colliderBox = {x=0, y=0, w=5, h=5}
    self.hitBox = {x=-4, y=-4, w=13, h=13}
    self.hurtBox = {x=0, y=0, w=5, h=5}

    self.state = "ground"
    --[[
        ground: player is on ground, continues forward
        air: player is in the air, spinning, effected by gravity
        dash: player is attacking
        hit: player just hit an attack, hasn't stopped moving yet
        posthit: player hit an attack, just stopped moving to allow a jump
        missed: player missed a dash, and can't control
        walled: hanging onto a wall
    ]]
    self.stateChange = 0 --time until state changes automatically

    self.canDash = false
    self.canJump = false
    self.spinAngle = 0
    self.spinDir = 0
    self.walledDir = 0 --direction *away from* the wall
    self.targetAngle = 0
    self.dashMultiplier = 1
end

function player:checkTargets()
    local maxProd = -1
    for i, v in ipairs(objects.drones) do
        if util.dist(objects.drones[i].pos.x, objects.drones[i].pos.y, self.pos.x, self.pos.y) < playerDashDuration*playerDashSpeed*self.dashMultiplier then
            local ang = math.atan2(objects.drones[i].pos.y-self.pos.y, objects.drones[i].pos.x-self.pos.x)
            local prod = util.dotProduct(math.cos(self.spinAngle), math.sin(self.spinAngle), math.cos(ang), math.sin(ang))
            if prod > maxProd then
                maxProd = prod
                self.targetAngle = ang
            end
        end
    end
    return maxProd > playerTargetThreshhold
end

function player:control(delta)
    if self.state == "ground" then
        local maxControlSpeed = math.max(playerMaxSpeedGround, math.abs(self.vel.x) - playerBoostSpeedLossGround)
        if controls.right > 0 then
            self.vel.x = self.vel.x + playerAccelerationGround * delta
        elseif controls.left > 0 then
            self.vel.x = self.vel.x - playerAccelerationGround * delta
        else
            --slow down at the same rate
            self.vel.x = self.vel.x - util.sign(self.vel.x) * playerAccelerationGround * delta
            if math.abs(self.vel.x) < 0.1 then
                self.vel.x = 0
            end
        end

        self.vel.x = util.constrain(self.vel.x, -1 * maxControlSpeed, maxControlSpeed)
    elseif self.state == "air" then
        --getting direction
        local x = 0
        if controls.left > 0 then x = x - 1 end
        if controls.right > 0 then x = x + 1 end
        local y = 0
        if controls.up > 0 then y = y - 1 end
        if controls.down > 0 then y = y + 1 end
        if y > 0 and x ~= 0 then x = x + self.vel.x*playerVelToDirInfluence end
        if x ~= 0 or y ~= 0 then
            self.spinAngle = math.atan2(y, x)
        end

        local maxControlSpeed = math.max(playerMaxSpeedAir, math.abs(self.vel.x) - playerBoostSpeedLoss)
        if controls.right > 0 then
            self.vel.x = self.vel.x + playerAccelerationAir * delta
        elseif controls.left > 0 then
            self.vel.x = self.vel.x - playerAccelerationAir * delta
        else
            --slow down at the same rate?
            self.vel.x = self.vel.x - util.sign(self.vel.x) * playerAccelerationAir * delta
            if math.abs(self.vel.x) < 0.1 then
                self.vel.x = 0
            end
        end

        self.vel.x = util.constrain(self.vel.x, -1 * maxControlSpeed, maxControlSpeed)
    end

    if controls.z > 0 then
        if self.state == "ground" then
            self.vel.y = playerGroundJumpVel
            self.state = "air"
            self.dashMultiplier = 1
            self.canDash = true
        elseif self.state == "walled" then
            self.state = "air"
            self.vel.y = playerWallJumpVelY
            self.vel.x = playerWallJumpVelX * self.walledDir
        end
    end

    if controls.x > 0 and self.canDash then
        if self.state == "air" then
            self.state = "dash"
            self.canDash = false
            if self:checkTargets() then
                self.spinAngle = self.targetAngle
            end
            self.vel.x = math.cos(self.spinAngle) * playerDashSpeed * self.dashMultiplier
            self.vel.y = math.sin(self.spinAngle) * playerDashSpeed * self.dashMultiplier
            self.stateChange = playerDashDuration
            spawnDirectionalExplosion(self.pos.x, self.pos.y, self.vel.x * playerExplosionMultiplier, self.vel.y * playerExplosionMultiplier)
        end
    end
end

function player:move(dx, dy)
    self.pos.x = self.pos.x + dx
    self.pos.y = self.pos.y + dy
    self.colliderBox.x = self.pos.x
    self.colliderBox.y = self.pos.y
    self.hurtBox.x = self.pos.x
    self.hurtBox.y = self.pos.y
    self.hitBox.x = self.pos.x-4
    self.hitBox.y = self.pos.y-4
end

function player:update(delta)
    self.stateChange = self.stateChange - delta
    if self.stateChange <= 0 then
        if self.state == "dash" then
            self.state = "missed"
            self.stateChange = playerMissTime
        elseif self.state == "missed" then
            self.state = "air"
        elseif self.state == "hit" then
            self.state = "posthit"
            self.stateChange = playerPostHitTime
        elseif self.state == "posthit" then
            self.state = "air"
            self.dashMultiplier = self.dashMultiplier + playerDashMultiplierIncrement
            --getting direction
            local x = 0
            if controls.left > 0 then x = x - 1 end
            if controls.right > 0 then x = x + 1 end
            local y = 0
            if controls.up > 0 then y = y - 1 end
            if controls.down > 0 then y = y + 1 end
            if x ~= 0 or y ~= 0 then
                local newDir = math.atan2(y, x)
                local mag = util.mag(self.vel.x, self.vel.y)
                if util.dotProduct(self.vel.x, self.vel.y, math.cos(newDir), math.sin(newDir)) > 0.9 then
                    self.vel.x = self.vel.x * playerHitBoost
                    self.vel.y = self.vel.y * playerHitBoost
                else
                    self.vel.x = math.cos(newDir) * mag
                    self.vel.y = math.sin(newDir) * mag
                end
            end
            if y == 0 then self.vel.y = playerAttackJumpVel end
            spawnDirectionalExplosion(self.pos.x, self.pos.y, self.vel.x * playerExplosionMultiplier, self.vel.y * playerExplosionMultiplier)
        end
    end

    if self.state == "walled" then
        self.vel.y = 0
        self.vel.x = 0
        self.canDash = true
    elseif self.state == "ground" then
        self.canDash = true
        self.dashMultiplier = 1
    elseif self.state == "posthit" then
        return true
    elseif self.state == "missed" then
        self.vel.x = self.vel.x * playerMissEffect
        self.vel.y = self.vel.y * playerMissEffect
    end

    self:move(0, self.vel.y * delta)
    if self.state == "ground" then self.state = "air" end --set to air, so the collision will set it back to ground (or not, if you fall)
    for i, v in ipairs(objects.buildings) do
        if util.intersect(self.colliderBox, objects.buildings[i].colliderBox) then
            self:move(0, -1 * self.vel.y * delta)
            self.vel.y = 0
            self.state = "ground"
        end
    end
    self:move(self.vel.x * delta, 0)
    for i, v in ipairs(objects.buildings) do
        if util.intersect(self.colliderBox, objects.buildings[i].colliderBox) then
            self:move(-1 * self.vel.x * delta, 0)
            if self.state ~= "ground" then
                self.state = "walled"
                self.walledDir = util.sign(-1 * self.vel.x) or 1
            end
        end
    end

    if self.state ~= "dash" then
        self.vel.y = self.vel.y + gravity * delta
        if controls.down > 0 then
            self.vel.y = self.vel.y + gravity * delta
        end
    end

    for i, v in ipairs(objects.drones) do
        if self.state == "dash" and util.intersect(self.hitBox, objects.drones[i].hurtBox) then
            --kill drone
            objects.drones[i]:kill(self.vel.x, self.vel.y)
            cameraShake = cameraShakeLevel
            self.canDash = true
            self.state = "hit"
            self.stateChange = playerHitTime
        end
        if self.state ~= "dash" and util.intersect(self.hurtBox, objects.drones[i].hitBox) then
            --kill player
        end
    end

    return true --never destroy player
end

function player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
    local radius = 7
    love.graphics.line(self.pos.x+2.5, self.pos.y+2.5, self.pos.x+2.5+math.cos(self.spinAngle)*radius, self.pos.y+2.5+math.sin(self.spinAngle)*radius)
    if self.state == "hit" or self.state == "posthit" then
        love.graphics.arc("fill", self.pos.x+2.5, self.pos.y+2.5, radius, self.spinAngle-math.pi/2, self.spinAngle+math.pi/2)
    end
end