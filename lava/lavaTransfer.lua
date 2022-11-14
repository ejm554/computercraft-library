-- Designed to transfer lava buckets
--  from a chest to a Create mod tank.
--  For a short-term project during
--  2021-04. Likely adaptable to other
--  projects.

local Y_DISTANCE = 7  -- Up/down
local Z_DISTANCE = 7  -- Fwd/back
local X_DISTANCE = 7  -- Side-to-side

local function moveUpAlongY()
  for i = 1, Y_DISTANCE do
    turtle.up()
  end
end

local function moveDownAlongY()
  for i = 1, Y_DISTANCE do
    turtle.down()
  end
end

local function moveForwardAlongZ()
  for i = 1, Z_DISTANCE do
    turtle.forward()
  end
end

local function moveBackwardAlongZ()
  for i = 1, Z_DISTANCE do
    turtle.back()
  end
end

local function moveForwardAlongX()
  for i = 1, X_DISTANCE do
    turtle.forward()
  end
end

local function moveBackwardAlongX()
  for i = 1, X_DISTANCE do
    turtle.back()
  end
end

----------
-- MAIN --
----------

-- Move from new system to old one.
moveUpAlongY()
moveForwardAlongZ()
turtle.turnLeft()
moveForwardAlongX()
turtle.down()
turtle.down()

-- Remove lava from obsolete chest.
for i = 1, 16 do
  turtle.select(i)
  turtle.suckDown()
end

-- Move from old system to new one.
turtle.up()
turtle.up()
moveBackwardAlongX()
turtle.turnRight()
moveBackwardAlongZ()
moveDownAlongY()

-- Drop lava into new system.
for i = 1, 16 do
  turtle.select(i)
  turtle.dropDown()
end

-- END OF PROGRAM --

