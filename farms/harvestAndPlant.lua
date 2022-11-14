-- Harvests and replants a row
--  of crops.
-- Item slots 1-4 are for seeds.
-- See footnotes for revision history 
--  and more.

-----------
-- SETUP --
-----------

local DO_ALTERNATE_HOEING = false
local DO_RESTRICTED_HARVESTING = false
local LAST_ROW = 4  -- number of rows
local LENGTH = 20
local SLEEP_AMOUNT = 1800  -- in seconds
  -- Note: 1800 sec is 30 mins.
local current_row = 1

local function hoeAndSow()
    local n = math.random(4)
    turtle.select(n)
    if DO_RESTRICTED_HARVESTING == false then
        turtle.digDown()  -- hoe
    elseif DO_RESTRICTED_HARVESTING == true then
        local itemExists, itemDetails = turtle.inspectDown()
        if itemDetails.name == "minecraft:pumpkin" then
            turtle.digDown() -- hoe
        end
    end
    turtle.suckDown()
    if DO_RESTRICTED_HARVESTING == false then
        turtle.placeDown()  -- sow
    end
end

local function changeDirection()
    if LAST_ROW == 1 then  -- for single-row farms
      turtle.turnRight()
      turtle.turnRight()
      for i = 1, LENGTH do
        turtle.dig()  --in case path is blocked
        turtle.forward()
      end
      turtle.turnRight()
      turtle.turnRight()
    elseif current_row == LAST_ROW and current_row % 2 == 0 then
        -- When row is the last one, and it's even, go back to start.
        turtle.turnRight()
        for i = 1, (LAST_ROW - 1) do
            turtle.dig()  -- in case path is blocked
            turtle.forward() end
        turtle.turnRight()
        current_row = 1  -- Reset row number.
    elseif current_row == LAST_ROW and current_row % 2 ~= 0 then
        -- When row is the last one, and it's odd, go back to start.
        turtle.turnRight()
        turtle.turnRight()
        for i = 1, LENGTH do
            turtle.dig()  --in case path is blocked
            turtle.forward()
          end
        turtle.turnRight()
        for i = 1, (LAST_ROW - 1) do
            turtle.dig()  -- in case path is blocked
            turtle.forward() end
        turtle.turnRight()
        current_row = 1  -- Reset row number.
    elseif current_row % 2 == 0 then 
        -- When row is even, go to next row using "option B."
        turtle.turnLeft()
        turtle.dig()  -- in case path is blocked
        turtle.forward()
        turtle.turnLeft()
        current_row = current_row + 1
        hoeAndSow()
    else                             
        -- When row is odd, go to next row using "option A."
        turtle.turnRight()
        turtle.dig() -- in case path is blocked
        turtle.forward()
        turtle.turnRight()
        current_row = current_row + 1
        hoeAndSow()
    end
end


---------------
-- MAIN CODE --
---------------
while true do
    term.clear()
    print("Harvesting...")
    for j = 1, LAST_ROW do  
        hoeAndSow()
        for i = 1, (LENGTH - 1) do
            turtle.dig() -- in case path is blocked
            turtle.forward()
            if DO_ALTERNATE_HOEING == true and i % 2 == 0 then
                print("Option 1")
                hoeAndSow()
            elseif DO_ALTERNATE_HOEING == true and i % 2 ~= 0 then
                print("Option 2")
                -- No action defined (yet). Later?
            else
                print("Option 3")
                hoeAndSow()
            end
        end
        changeDirection()
    end

    for i = SLEEP_AMOUNT, 1, -1 do
        term.clear()
        local maxMinutes = math.ceil(i / 60)
        print("Program running.")
        print("Press & hold Ctrl+T to stop.")
        print("----------------------------")
        print("Harvest will take place in ")
        print(i .. " seconds (less than " .. maxMinutes .. " minutes).")
        os.sleep(1)
    end
end

--[[ 

---------------
-- FOOTNOTES --
---------------

Revision History:
- Added feature that would allow
  restricted harvesting. For now, it is
  limited to pumpkins, but it may evolve
  to more crops. (2021-06-02)
- Added feature that will hoe alternate
  spaces in a row, which can be useful
  for melons and pumpkins. (2021-05-31)
- Fixed bug to allow correct return-to-
  start while odd rows. (2021-05-29)
- Added dig() functions (2021-05-28)

 ]]
