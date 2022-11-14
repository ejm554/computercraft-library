local function digAndMoveDownOnce ()
  --reportStatusToLog("The digAndMoveDownOnce() function started.")
  turtle.digDown()
  turtle.down()
  --trackMovement("negativeY_Movement")
  --reportStatusToLog("  The digAndMoveDownOnce() function ended.")
  -- TODO: Consider feature that will avoid digging when block is air.
end

local function maybePlantASapling ()
  -- Maybe plant a sapling from Slot 1.
  local randomPlanting = math.random(10)
  if randomPlanting == 1 then
    turtle.select(1)
    turtle.up()
    turtle.placeDown()
  end
end

local function decendToGround ()
  --reportStatusToLog("The decendToGround() function started.")
  --local blockInfo = {}  -- Contains inspection info for a block

  local blockDoesExist, blockInfo = turtle.inspectDown()
  -- If air or tree element, dig and move down.
  if blockDoesExist == false or blockInfo.tags["minecraft:leaves"] or blockInfo.tags["minecraft:logs"] or blockInfo.tags["minecraft:saplings"] then
      digAndMoveDownOnce()
      decendToGround()  -- Recursive call
  -- Otherwise, assume block is ground or a non-diggable item.
  else
      for i = 1,4 do
          turtle.suck()
          turtle.turnLeft()
      end
      maybePlantASapling()
  end
  
  --reportStatusToLog("  The decendToGround() function ended.")
end

----------
-- MAIN --
----------
decendToGround()