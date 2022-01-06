function player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    if self.state == "ground" then
        if math.abs(self.vel.x) > 0.1 then
            self:drawRunning()
        else
            self:drawStanding()
        end
    elseif self.state == "air" then
        self:drawAir()
    elseif self.state == "dash" then
        self:drawDash()
    elseif self.state == "hit" or self.state == "posthit" then
        love.graphics.setColor(colorRed3)
        love.graphics.arc("fill", self.pos.x+2.5, self.pos.y+2.5, animSlashRadius, self.spinAngle-math.pi/2, self.spinAngle+math.pi/2)
    else
        self:drawAir()
    end
end

function player:drawRunning()
    frame = math.floor(self.runFrame)
    love.graphics.draw(
        images.player,
        love.graphics.newQuad(frame*6, 0, 5, 5, 47, 11),
        util.round(self.pos.x + util.map(self.dir, 1, -1, 0, 5)),
        util.round(self.pos.y) + 1,
        0,
        self.dir,
        1
    )
end

function player:drawStanding()
    love.graphics.draw(
        images.player,
        love.graphics.newQuad(0, 6, 5, 5, 47, 11),
        math.floor(self.pos.x),
        math.floor(self.pos.y) + 1,
        0,
        1,
        1
    )
end

function player:drawAir()
    local xf = 1
    if self.vel.y > 0 then xf = 2 end
    love.graphics.draw(
        images.player,
        love.graphics.newQuad(xf*6, 6, 5, 5, 47, 11),
        util.round(self.pos.x + util.map(self.dir, 1, -1, 0, 5)),
        util.round(self.pos.y) + 1,
        0,
        self.dir,
        1
    )
end

function player:drawDash()
    if self.vel.y > 0 then xf = 2 end
    love.graphics.draw(
        images.player,
        love.graphics.newQuad(12, 0, 5, 5, 47, 11),
        util.round(self.pos.x + util.map(self.dir, 1, -1, 0, 5)),
        util.round(self.pos.y) + 1,
        0,
        self.dir,
        1
    )
end