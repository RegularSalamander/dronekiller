building = class:new()
function building:init(x, y, w, h)
    h = h or 1000
    self.colliderBox = {x=x, y=y, w=w, h=h}
end

function building:update()
    return  lastX - self.colliderBox.x < purgeDistance
end

function building:draw()
    love.graphics.setColor(colorGray2)
    love.graphics.rectangle("fill", self.colliderBox.x, self.colliderBox.y, self.colliderBox.w, self.colliderBox.h)
    if self.colliderBox.w == 40 and self.colliderBox.h == 17 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(images.sign, self.colliderBox.x, self.colliderBox.y)
    end
end