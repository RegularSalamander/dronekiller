building = class:new()
function building:init(x, y, w, h)
    h = h or 1000
    self.colliderBox = {x=x, y=y, w=w, h=h}
end

function building:draw()
    love.graphics.setColor(colorGray2)
    love.graphics.rectangle("fill", self.colliderBox.x, self.colliderBox.y, self.colliderBox.w, self.colliderBox.h)
    -- love.graphics.setColor(colorPurple2)
    -- love.graphics.rectangle("fill", self.colliderBox.x+2, self.colliderBox.y+2, 2, self.colliderBox.h-4)--left
    -- love.graphics.rectangle("fill", self.colliderBox.x+self.colliderBox.w-4, self.colliderBox.y+2, 2, self.colliderBox.h-4)--right
    -- love.graphics.rectangle("fill", self.colliderBox.x+2, self.colliderBox.y+2, self.colliderBox.w-4, 2)--top
    --love.graphics.rectangle("fill", self.colliderBox.x+self.colliderBox.w-2, self.colliderBox.y+2, self.colliderBox.w-4, 2)--bottom
end