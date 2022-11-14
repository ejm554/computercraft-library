-- Chops a single tree.
-- Start with turtle facing the
--  bottom of the trunk.
-- Author: EJM, 2021-03-13

height = 15

turtle.dig()
turtle.forward()

for i = 1,height do
  turtle.digUp()
  turtle.up()
end

for j = 1,height do
  turtle.down()
end

