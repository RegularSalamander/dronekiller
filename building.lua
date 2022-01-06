building = class:new()
function building:init(x, y, w)
    self.colliderBox = {x=x, y=y, w=w, h=1000}
end

function building:draw()
    love.graphics.setColor(colorGray2)
    love.graphics.rectangle("fill", self.colliderBox.x, self.colliderBox.y, self.colliderBox.w, self.colliderBox.h)
end