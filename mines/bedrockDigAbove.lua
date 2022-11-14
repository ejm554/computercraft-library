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


local LENGTH = 16  -- Front to back
local WIDTH = 5    -- Side to side, rows
local depth = 0
local randomSlot   -- For Slots 1-4

local function isBlockBelowBedrock()
  local blockExists, blockData = turtle.inspectDown()
  if blockData.name == "minecraft:bedrock" then
    return true
  else
    return false
  end
end

local function digDownToBedrock()
  --TODO: Fix: Handle scenario when block below is air.
  --while turtle.digDown() == true do
  while isBlockBelowBedrock() == false do  
    turtle.digDown()
    turtle.down()
    depth = depth + 1
  end
end

local function goUpDepthFromBedrock()
  -- TODO: Allow program to place from multiple slots, not just Slot 1.
  -- TODO: Determine if there's a way avoid placing two items when depth == 1 or == 2.
  if depth == 1 then
    turtle.up()
    -- randomSlot = math.random(4)
    -- turtle.select(randomSlot)
    turtle.select(1)
    turtle.placeDown()
    turtle.placeDown() -- Need twice if slabs. Bug?
    depth = 0
  elseif depth == 3 then
    turtle.up()
    turtle.select(5)  -- for torches, etc., in Slot 5
    turtle.placeDown()
    for i = 1, (depth - 1) do
      turtle.up()
    end
    turtle.select(1)  -- resets to program default
    turtle.placeDown()
    depth = 0
  elseif depth >= 2 then  -- excluding 3
    for i = 1, depth do
      turtle.up()
    end
    turtle.select(1)
    turtle.placeDown()
    depth = 0
  else
    -- depth must be 0, so do nothing,
  end
end

----------
-- MAIN --
----------
for j = 1, WIDTH do

  for i = 1, LENGTH do
    digDownToBedrock()
    goUpDepthFromBedrock()
    
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

