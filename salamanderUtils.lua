local util = {}

function util.dist(a, b, c, d)
    return math.sqrt(math.pow(a-c, 2) + math.pow(b-d, 2))
end

function util.mag(x, y)
    return dist(0, 0, x, y)
end

function util.map(item, min1, max1, min2, max2)
    return ((item-min1)/(max1-min1))*(max2-min2)+min2;
end

function util.sign(a)
    if(a == 0) then return 1 end
    return a / math.abs(a)
end

function util.constrain(item, min, max)
    return math.min(math.max(item, min), max)
end

function util.round(num, numDecimalPlaces)
    if numDecimalPlaces == nil then numDecimalPlaces = 0 end
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function util.randRange(min, max)
    return math.random()*(max-min) + min
end

function util.randInt(min, max)
    return math.floor(math.random()*(max-min+1) + min)
end

function util.intersect(quad1, quad2)
    return (
        quad1.x < quad2.x + quad2.w and
        quad1.y < quad2.y + quad2.h and
        quad1.x + quad1.w > quad2.x and
        quad1.y + quad1.h > quad2.y
    )
end

function util.intersectInclusive(quad1, quad2)
    return (
        quad1.x <= quad2.x + quad2.w and
        quad1.y <= quad2.y + quad2.h and
        quad1.x + quad1.w >= quad2.x and
        quad1.y + quad1.h >= quad2.y
    )
end

function util.drawLoopOld(list)
    for i = 1, #list do
        list[i].draw()
    end
end

function util.updateLoopOld(list, delta)
    for i = 1, #list do
        list[i].update(delta)
    end
end

function util.drawLoop(list)
    for i = 1, #list do
        list[i]:draw()
    end
end

function util.updateLoop(list, delta)
    for i = 1, #list do
        list[i]:update(delta)
    end
end
 
function util.killLoop(list)
    for i = #list, 1, -1 do
        if not list[i].alive then
            table.remove(list, i)
        end
    end
end

function util.removeXFromQuad(quad1, quad2)
    local list = {}
    if quad1.x < quad2.x then
       table.insert(list, {x=quad1.x, y=quad1.y, w=math.min(quad1.w, quad2.x-quad1.x), h=quad1.h})
    end
    if quad1.x+quad1.w > quad2.x+quad2.w then
       table.insert(list, {x=math.max(quad1.x, quad2.x+quad2.w), y=quad1.y, w=math.min(quad1.w, (quad1.x+quad1.w)-(quad2.x+quad2.w)), h=quad1.h})
    end
    return list
end
 
function util.removeYFromQuad(quad1, quad2)
    local list = {}
    if quad1.y < quad2.y then
       table.insert(list, {x=quad1.x, y=quad1.y, h=math.min(quad1.h, quad2.y-quad1.y), w=quad1.w})
    end
    if quad1.y+quad1.h > quad2.y+quad2.h then
       table.insert(list, {y=math.max(quad1.y, quad2.y+quad2.h), x=quad1.x, h=math.min(quad1.h, (quad1.y+quad1.h)-(quad2.y+quad2.h)), w=quad1.w})
    end
    return list
end

return util