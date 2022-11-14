-- Fills holes in ground, such as 
--  those left by Creepers. 
-- INSTRUCTIONS:
--  * Put desired fill material, e.g., 
--    dirt, in item slot 1.
--  * To define a specific length of
--    blocks to fill, run this program
--    with an integer as an argument.

-- Define variables & default values. --
local depth = 0
if arg[1] == nil then
  arg[1] = 1
end

-- Main program --
for j = 1, arg[1] do

  print("Moving to hole " .. j .. ".")
  turtle.forward()

  print("1. Depth before inspection is " .. depth .. ".")

  while turtle.inspectDown() == false do
    turtle.down()
    depth = depth + 1
  end

  print("2. Depth after inspection is " .. depth .. ".")

  if depth > 0 then
    for i = 1, depth do
      turtle.up()
      turtle.placeDown()
      depth = depth - 1
    end
  end

  print("3. Depth after filling is " .. depth .. ".")

end