player = class:new()
function player:init()
    self.pos = {x=0, y=0}
    self.vel = {x=0, y=0}
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

function player:control()
    
end

function player:update()
    
end