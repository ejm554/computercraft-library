for a = 1,3 do

  for o = 1,30 do
    
   turtle.digDown()
   turtle.down()
  
   for i = 1,4 do
     turtle.dig()
     turtle.turnLeft()
   end
  
  end

  for u = 1,30 do
    turtle.up()
  end

  turtle.forward()
  turtle.forward()

  turtle.turnLeft()
  turtle.forward()
  turtle.turnRight()

end
