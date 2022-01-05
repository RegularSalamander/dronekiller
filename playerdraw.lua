function player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
    self:drawRunFrame()
    local radius = 7
    --love.graphics.line(self.pos.x+2.5, self.pos.y+2.5, self.pos.x+2.5+math.cos(self.spinAngle)*radius, self.pos.y+2.5+math.sin(self.spinAngle)*radius)
    if self.state == "hit" or self.state == "posthit" then
        love.graphics.arc("fill", self.pos.x+2.5, self.pos.y+2.5, radius, self.spinAngle-math.pi/2, self.spinAngle+math.pi/2)
    end
end

function player:drawRunFrame()
    frame = math.floor(self.runFrame)
    love.graphics.draw(
        images.player,
        love.graphics.newQuad(frame*6, 0, 5, 5, 47, 5), --7 pixels wide, 8 pixels because of the one pixel gap
        math.floor(self.pos.x + util.map(self.dir, 1, -1, 0, 5)),
        math.floor(self.pos.y) + 1, -- plus one because when floored it always floats above the ground
        0,
        self.dir,
        1
    )
end