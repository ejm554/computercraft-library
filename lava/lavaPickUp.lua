-- Gathers lava, if empty buckets
--   exist in inventory.
-- INSTRUCTIONS: 
--   * Place 16 (or less) empty 
--     buckets in Slot 1.
--   * Leave other slots empty to
--     make space for filled buckets.
-- WARNING: 
--   This program is designed to
--   "place" the items from Slot 1 
--   into lava. Users should avoid
--   using that slot for valuables.

local LENGTH = 16

-- Go forward, try to gather lava.
for i = 1, LENGTH do
  turtle.select(1)
  turtle.dig()  --just in case
  
  -- Place item in Slot 1, e.g., bucket.
  turtle.place()
  turtle.forward()
end
   
-- Return to start.   
for i = 1, LENGTH do
  turtle.select(16)
  turtle.back()
  
  -- Place item in Slot 16, e.g., stone.
  turtle.place()
end
