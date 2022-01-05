function spawnLargeExplosion(x, y)
    for i = 1, 10 do
        table.insert(objects.explosions, explosion:new(
            x + util.randRange(-1 * explosionInitialSpread, explosionInitialSpread),
            y + util.randRange(-1 * explosionInitialSpread, 0),
            "fire"
        ))
    end
    for i = 1, 10 do
        table.insert(objects.explosions, explosion:new(
            x + util.randRange(-1 * explosionInitialSpread, explosionInitialSpread),
            y + util.randRange(0, explosionInitialSpread),
            "smoke"
        ))
    end
    table.insert(objects.explosions, explosion:new(x, y, "flash"))
end

function spawnSmallExplosion(x, y)
    for i = 1, 3 do
        table.insert(objects.explosions, explosion:new(
            x + util.randRange(-1 * explosionSmallInitialSpread, explosionSmallInitialSpread),
            y + util.randRange(-1 * explosionSmallInitialSpread, 0),
            "fire"
        ))
    end
end

function spawnDirectionalExplosion(x, y, dx, dy)
    for i = 1, 3 do
        table.insert(objects.explosions, explosion:new(
            x + util.randRange(-1 * explosionSmallInitialSpread, explosionSmallInitialSpread),
            y + util.randRange(-1 * explosionSmallInitialSpread, 0),
            "fire",
            dx,
            dy
        ))
    end
end

explosion = class:new()
function explosion:init(x, y, type, dx, dy)
    dx = dx or 0
    dy = dy or 0

    self.pos = {x=x, y=y}
    self.type = type
    if self.type == "flash" then
        self.vel = {x=0, y=0}
        self.timeUntilActive = 2
        self.timeToLive = 5
        self.rad = 15
    end
    if self.type == "fire" then
        self.vel = {
            x = dx + util.randRange(-1 * explosionSpread, explosionSpread),
            y = dy + util.randRange(-1 * explosionSpread, 0)
        }
        self.timeUntilActive = math.random() * 15
        if dx ~= 0 or dy ~= 0 then self.timeUntilActive = 0 end
        self.timeToLive = 60 - math.random() * 10
        self.rad = 3
    end
    if self.type == "smoke" then
        self.type = "fire"
        self.vel = {
            x = dx + util.randRange(-1 * explosionSpread, explosionSpread),
            y = dy + util.randRange(-1 * explosionSpread, explosionSpread)
        }
        self.timeUntilActive = 7 + math.random() * 15
        self.timeToLive = 30
        self.rad = 3
    end
end
function explosion:update(delta)
    if self.timeUntilActive > 0 then
        self.timeUntilActive = self.timeUntilActive - delta
        return true
    end

    self.timeToLive = self.timeToLive - delta

    if self.type == "flash" then
        self.rad = self.rad + delta
    end
    if self.type == "fire" then
        self.rad = self.rad + delta * math.pow(self.timeToLive, 3) * 0.000004
    end
    self.pos.x = self.pos.x + self.vel.x * delta
    self.pos.y = self.pos.y + self.vel.y * delta

    return self.timeToLive > 0
end

function explosion:draw()
    if self.timeUntilActive > 0 then
        return
    end
    if self.type == "flash" then
        love.graphics.setColor(1, 1, 1, 1)
    elseif self.type == "fire" then
        if self.timeToLive > 55 then
            love.graphics.setColor(255/255, 247/255, 104/255, 1)
        elseif self.timeToLive > 45 then
            love.graphics.setColor(246/255, 168/255, 10/255, 1)
        elseif self.timeToLive > 30 then
            love.graphics.setColor(189/255, 46/255, 12/255, 1)
        elseif self.timeToLive > 10 then
            love.graphics.setColor(69/255, 10/255, 14/255, 1)
        else
            local fade = self.timeToLive / 10
            love.graphics.setColor(69/255, 10/255, 14/255, 0)--fade)
        end
    end
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.rad)
end