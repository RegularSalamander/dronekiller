player = class:new()
function player:init()
    self.pos = {x=0, y=0}
    self.vel = {x=0, y=0}
    
    self.colliderBox = {x=0, y=0, h=5, w=5}
    self.hitBox = {x=0, y=0, h=5, w=5}
    self.hurtBox = {x=0, y=0, h=5, w=5}

    self.state = "ground"
    --[[
        ground: player is on ground, continues forward
        air: player is in the air, spinning, effected by gravity
        dash: player is attacking
        attackhit: player hit an attack, and has these frames to pick a direction
    ]]
    self.stateChange = 0 --time until state changes automatically
    self.canDash = false
    self.canJump = false
    self.spinAngle = 0
end

function player:control(controls, delta)
    if self.state == "ground" then
        if controls.right > 0 then
            self.vel.x = self.vel.x + playerAccelerationOnGround * delta
        elseif controls.left > 0 then
            self.vel.x = self.vel.x - playerAccelerationOnGround * delta
        else
            --slow down at the same rate?
            self.vel.x = self.vel.x - util.sign(self.vel.x) * playerAccelerationOnGround * delta
            if math.abs(self.vel.x) < 0.1 then
                self.vel.x = 0
            end
        end
        --constrain speed
        self.vel.x = util.constrain(self.vel.x, -1 * playerMaxSpeedOnGround, playerMaxSpeedOnGround)
    end
end

function player:update(delta)
    self.pos.y = self.pos.y + self.vel.y
    self.pos.x = self.pos.x + self.vel.x

    self.vel.y = self.vel.y + 0.01 * delta
end

function player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
end