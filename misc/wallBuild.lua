-- Builds a wall.
-- Parameters:
-- 1. length (req'd; int > 0)
-- 2. height (opt; int > 0; default: 1)
-- 3. isDiagonal (opt; default: false)

--#region Setup
local LENGTH = tonumber(arg[1])
local HEIGHT = tonumber(arg[2]) or 1

-- Should turtle build behind itself as it travels (vs underneath)? Default: false
--  This is useful when replacing an existing wall.
local DO_BUILD_BEHIND = false

-- Should turtle can build along a diagonal line (vs a straight one)? Default: false
local IS_DIAGONAL = false

-- Should turtle drop blocks/items that it digs (vs collecting afterwards)? Default: false
--  Setting this to 'true' overrides standard turtle behavior.
local DO_DROP_AFTER_DIG = false

--#endregion

--#region ErrorHandling
if #arg == 0 then
  printError("<!> Oops, you need to specify a length argument.")
  printError(" Example: wallBuild 16")
  return
elseif LENGTH <= 0 or HEIGHT <= 0 or (LENGTH % 1) ~= 0 or (HEIGHT % 1) ~= 0 then
  printError("<!> Silly rabbit! You used a bizarre number to specify the length or height! Try again with a positive integer.")
  return
end
if turtle.getItemCount(1) == 0 then
  printError("<!> Slot 1 is empty. It requires building materials in order to continue.")
  return
elseif LENGTH > turtle.getItemCount(1) then
  printError("<!> There aren't enough items in Slot 1 for the length that you specified. Please put an adequate amount of items in Slot 1 or specify a shorter length.")
  return
end
if turtle.getItemCount(16) ~= 0 then
  printError("<!> Sorry, but Slot 16 is reserved for use by the program. Please empty it, and try again.")
  return
end
--endregion

--#region Functions
local function digDown_ButProvisionallySuckItem()
  local previousSlot = turtle.getSelectedSlot()
  turtle.select(16)
  turtle.digDown()
  if DO_DROP_AFTER_DIG == true then
    turtle.dropUp()
  end
  turtle.select(previousSlot)
end

local function dig_ButProvisionallySuckItem()
  local previousSlot = turtle.getSelectedSlot()
  turtle.select(16)
  turtle.dig()
  if DO_DROP_AFTER_DIG == true then
    turtle.dropUp()
  end
  turtle.select(previousSlot)
end

local function turnOneEighty()
  turtle.turnLeft()
  turtle.turnLeft()
end
--#endregion

--#region Main
----------
-- MAIN --
----------
print("---- Program Started ----")

if DO_BUILD_BEHIND == false and IS_DIAGONAL == false then
  turtle.select(1)
  digDown_ButProvisionallySuckItem()
  for i = 1, (LENGTH - 1) do
    turtle.placeDown()
    dig_ButProvisionallySuckItem()  --in case block in front
    turtle.forward()
    digDown_ButProvisionallySuckItem()
  end
  turtle.placeDown()

elseif DO_BUILD_BEHIND == true and IS_DIAGONAL == false then
  turtle.select(1)
  dig_ButProvisionallySuckItem()
  turtle.forward()
  for i = 1, (LENGTH - 2) do
    turnOneEighty()
    turtle.place()
    turnOneEighty()
    dig_ButProvisionallySuckItem()
    turtle.forward()
  end
  turnOneEighty()
  turtle.place()  -- TODO: Why isn't this placing an item?
  turnOneEighty()

elseif DO_BUILD_BEHIND == false and IS_DIAGONAL == true then
  turtle.select(1)
  for i = 1, (LENGTH - 1) do
    digDown_ButProvisionallySuckItem()
    turtle.placeDown()
    turtle.turnRight()
    dig_ButProvisionallySuckItem() -- in case block is in the way
    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
  end
  digDown_ButProvisionallySuckItem()
  turtle.placeDown()
else 
  printError("<!> Hmmm. Something went wrong in the main procedure.")
end


print("===== Program Ended =====")
print("")
--#endregion
