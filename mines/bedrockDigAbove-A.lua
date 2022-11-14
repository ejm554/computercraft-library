-- Designed to remove all blocks
--  above bedrock
-- Instructions:
-- + In Slots 1-4, put slabs or other 
--    desired blocks for the a new 
--    "floor." Any non-bedrock blocks 
--    below this floor will be empty 
--    space.
-- + In Slot 5, put torches or other 
--   items that can act as a light 
--   source. These will be added to 
--   any bedrock blocks that have 
--   exactly one empty space between
--   it and the new "floor."


local LENGTH = 8  -- Front to back
local WIDTH = 4    -- Side to side, rows
local randomSlot   -- For Slots 1-4

local function digDownToBedrock()
  --TODO: Fix: Handle scenario when
  --  block below is air.
  
  local DEPTH = 0
  -- TODO: Change DEPTH to lowercase; it's a variable.

  while turtle.digDown() == true do
    turtle.down()
    DEPTH = DEPTH + 1
  end

  -- TODO: Allow program to place
  --   from multiple slots, not just
  --   Slot 1.
  -- TODO: Determine if there's a way
  --   avoid placing two items when
  --   DEPTH == 1 or == 2.
  if DEPTH == 1 then
    turtle.up()
    randomSlot = math.random(4)
    turtle.select(randomSlot)
    turtle.placeDown()
    turtle.placeDown() -- Need twice if slabs. Bug?
  elseif DEPTH == 2 then
    turtle.up()
    turtle.select(5)  -- for torches, etc., in Slot 5
    turtle.placeDown()
    randomSlot = math.random(4)
    turtle.select(randomSlot)
    turtle.placeDown()
    --turtle.placeDown() -- Need twice if slabs. Bug?
  elseif DEPTH > 2 then
    for i = 1, DEPTH do
      turtle.up()
    end
    turtle.placeDown()
  else
    -- DEPTH must be 0, so do nothing,
  end
end

----------
-- MAIN --
----------
for j = 1, WIDTH do

  for i = 1, LENGTH do
    digDownToBedrock()
    
    -- Don't move forward if at last column.
    if i < LENGTH then 
      turtle.dig()  -- In case path blocked.
      turtle.forward()
    end
 
  end

  -- Shorten last step in loop on
  --  account of 1 < LENGTH, above.
  for i = 1, (LENGTH - 1) do
    turtle.back()
  end

  turtle.turnRight()
  turtle.dig()  -- In case path blocked.
  turtle.forward()
  turtle.turnLeft()
end

