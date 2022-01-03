player = class:new()
function player:init()
    self.pos = {x=0, y=0}
    self.vel = {x=0, y=0}
    
    self.colliderBox = {x=0, y=0, w=5, h=5}
    self.hitBox = {x=0, y=0, w=5, h=5}
    self.hurtBox = {x=0, y=0, w=5, h=5}

    self.state = "ground"
    --[[
        ground: player is on ground, continues forward
        air: player is in the air, spinning, effected by gravity
        dash: player is attacking
        attackhit: player hit an attack, and has these frames to pick a direction
        walled: hanging onto a wall
    ]]
    self.stateChange = 0 --time until state changes automatically
    self.canDash = false
    self.canJump = false
    self.spinAngle = 0
    self.walledDirection = 0 --direction *away from* the wall
end

function player:control(controls, delta)
    if self.state == "ground" then
        if controls.right > 0 then
            self.vel.x = self.vel.x + playerAccelerationGround * delta
        elseif controls.left > 0 then
            self.vel.x = self.vel.x - playerAccelerationGround * delta
        else
            --slow down at the same rate?
            self.vel.x = self.vel.x - util.sign(self.vel.x) * playerAccelerationGround * delta
            if math.abs(self.vel.x) < 0.1 then
                self.vel.x = 0
            end
        end
        --constrain speed
        self.vel.x = util.constrain(self.vel.x, -1 * playerMaxSpeedGround, playerMaxSpeedGround)
    elseif self.state == "air" then
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
        --constrain speed
        self.vel.x = util.constrain(self.vel.x, -1 * playerMaxSpeedAir, playerMaxSpeedAir)
    end

    if controls.z > 0 then
        if self.state == "ground" then
            self.vel.y = playerGroundJumpVel
            self.state = "air"
        elseif self.state == "walled" then
            self.state = "air"
            self.vel.y = playerWallJumpVelY
            self.vel.x = playerWallJumpVelX * self.walledDirection
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
    self.hitBox.x = self.pos.x
    self.hitBox.y = self.pos.y
end

function player:update(delta)
    if self.state == "walled" then
        self.vel.y = 0
        self.vel.x = 0
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
            if self.state == "air" then
                self.state = "walled"
                self.walledDirection = util.sign(-1 * self.vel.x)
            end
        end
    end

    self.vel.y = self.vel.y + gravity * delta
end

function player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
end