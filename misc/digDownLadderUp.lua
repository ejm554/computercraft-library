-- Digs a hole straight down, then
--  places a ladder on its way back
--  up. REQUIRES a ladder in Slot 1.
-- Also places a single torch from
--  Slot 2.
-- See footnotes for revision history 
--  and more.

HEIGHT = 16

for i = 1, HEIGHT do
  turtle.digDown()
  turtle.down()
end

turtle.up()
turtle.select(2) 
turtle.placeDown()
--turtle.up()

for i = 1, (HEIGHT - 1) do
  turtle.select(1)  
  turtle.up()
  turtle.placeDown()
end

--[[ 

---------------
-- FOOTNOTES --
---------------

Revision history:

- Adjusted .up() and second loop so turtle to 
   correct some height issues.
- File copied from Computer 9.

 ]]