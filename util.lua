function dist(a, b, c, d)
    return math.sqrt(math.pow(a-c, 2) + math.pow(b-d, 2))
end

function mag(x, y)
    return dist(0, 0, x, y)
end

function map(item, min1, max1, min2, max2)
    return ((item-min1)/(max1-min1))*(max2-min2)+min2;
end

function sign(a)
    if(a == 0) then return 1 end
    return a / math.abs(a)
end

function round(num, numDecimalPlaces)
    if numDecimalPlaces == nil then numDecimalPlaces = 0 end
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function constrain(x, min, max)
   return math.max(min, math.min(max, x))
end

function table.show(t, name, indent) --I didn't write this
    local cart     -- a container
    local autoref  -- for self references
 
    --[[ counts the number of elements in a table
    local function tablecount(t)
       local n = 0
       for _, _ in pairs(t) do n = n+1 end
       return n
    end
    ]]
    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end
 
    local function basicSerialize (o)
       local so = tostring(o)
       if type(o) == "function" then
          local info = debug.getinfo(o, "S")
          -- info.name is nil because o is not a calling level
          if info.what == "C" then
             return string.format("%q", so .. ", C function")
          else 
             -- the information is defined through lines
             return string.format("%q", so .. ", defined in (" ..
                 info.linedefined .. "-" .. info.lastlinedefined ..
                 ")" .. info.source)
          end
       elseif type(o) == "number" or type(o) == "boolean" then
          return so
       else
          return string.format("%q", so)
       end
    end
 
    local function addtocart (value, name, indent, saved, field)
       indent = indent or ""
       saved = saved or {}
       field = field or name
 
       cart = cart .. indent .. field
 
       if type(value) ~= "table" then
          cart = cart .. " = " .. basicSerialize(value) .. ";\n"
       else
          if saved[value] then
             cart = cart .. " = {}; -- " .. saved[value] 
                         .. " (self reference)\n"
             autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
          else
             saved[value] = name
             --if tablecount(value) == 0 then
             if isemptytable(value) then
                cart = cart .. " = {};\n"
             else
                cart = cart .. " = {\n"
                for k, v in pairs(value) do
                   k = basicSerialize(k)
                   local fname = string.format("%s[%s]", name, k)
                   field = string.format("[%s]", k)
                   -- three spaces between levels
                   addtocart(v, fname, indent .. "   ", saved, field)
                end
                cart = cart .. indent .. "};\n"
             end
          end
       end
    end
 
    name = name or "__unnamed__"
    if type(t) ~= "table" then
       return name .. " = " .. basicSerialize(t)
    end
    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
 end