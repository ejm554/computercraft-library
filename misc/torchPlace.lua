-- Designed to place torches on a
--  surface at a given interval.
--  Useful for illuminating the
--  ground to prevent mob spawning.
-- Slot 1 should contain torches.

local DISTANCE = 16
local INTERVAL = 8
local blockExists, blockData

turtle.select(1)
for j = 1, (DISTANCE / INTERVAL) do
    blockExists, blockData = turtle.inspectDown()
    if turtle.detectDown() == true then
        if blockData.name ~= "minecraft:torch" then
            turtle.up()
            turtle.placeDown()
        end
    end
    for i = 1, INTERVAL do
        turtle.forward()
    end
    turtle.placeDown()
end
