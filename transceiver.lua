transceiver = class:new()
function transceiver:init(x, y)
    self.pos = {x=x, y=y}
    self.hurtBox = {x=x, y=y, w=3, h=2}
    self.active = true
end

function transceiver:draw()
    love.graphics.setColor(1, 1, 1, 1)
    if transceiverHealth > 0 then
        love.graphics.draw(images.transceiver, self.pos.x - 4, self.pos.y)
    else
        love.graphics.draw(images.transceiverDead, self.pos.x - 4, self.pos.y)
    end
end

function transceiver:kill(dx, dy)
    transceiverHealth = transceiverHealth - 1
    spawnLargeExplosion(self.pos.x, self.pos.y)
    if transceiverHealth == 0 then
        pointRally = pointRally + 10000
        spawnGiantExplosion(self.pos.x, self.pos.y)
        spawnGiantExplosion(self.pos.x, self.pos.y)
        triggerRandomDialog(endDialog, true)
    end
end