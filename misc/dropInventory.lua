-- Drops the entire inventory.

local length = 5

for i = 1, length do
    turtle.forward()
end

for i = 1, 16 do
    turtle.select(i)
    turtle.drop()
end

for i = 1, length do
    turtle.back()
end

