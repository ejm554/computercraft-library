--[[
Chops any trees in a given area.
Start with a chest on the ground and 
  a fueled, empty turtle on top of it. 
  Both should be in a corner of the 
  area to be farmed. Turtle must face 
  direction of maximum length and be 
  to the left of the maximum width. 
Author: EJM, 2021-03-14
--]]

-- Initialize starting values.
    -- Minimum fuel level
    -- Maximum length, width (# blocks) 
    -- Maximum height (Y coordinate)
    MIN_FUEL = 250
    MAX_LENGTH = 68 -- Blocks, along X
    MAX_WIDTH = 69  -- Blocks, along Z
    MAX_HEIGHT = 81 -- Y coordinate

-- If not at minimum fuel, throw error 
--  and end program.

-- LOOP: Do this for max length:
--  If block under turtle is wood or leaves, 
--      dig down one and move down one.
--  Else, move back to starting height. 
--  * = Dirt, grasses, flowers, chests, 
--      water, sand, cactus, etc.
_, t = turtle.inspectDown()
If t.tags["minecraft:logs"] or t.tags["minecraft:leaves"] Then
    turtle.digDown()
    turtle.down()
Else 

-- WHEN at starting height:
--  Determine if any length remains.
--   If True: move forward one, 
--      perform loop above.
--   If False: back up to start of 
--      length.
--
--  Determine if any width remains.
--   If True: Turn right, 
--      move forward one, turn left,
--      perform loop above.
--   If False: Return to start,
--      transfer contents to chest. 
--      (Turn left, move forward width, 
--      turn right, move down to 
--      chest).
--   Question: What happens if chest is full? 