--------------------------------------
-- Farms trees over an uneven terrain.
-- See footnotes for add'l detail.
--------------------------------------

--region I
-- ###################################  
--          INITIALIZATIONS
-- ###################################

-- Initialize constants.
local MAX_X = 2  -- Side-to-side, "slices", relative to an origin in a 3D "zone" of trees
local MAX_Y = 30  -- Up-to-down, "column/slice height", relative to origin of "zone"
local MAX_Z = 2  -- Forward-to-back, "individual column", relative to origin of "zone"
local STARTING_X = 1  -- 1 is 1st slice (leftmost side), 2 is on 1's immediate right, etc.
local STARTING_Y = 1  -- 0 is just below ground, 1 is ground level, 2 is next block up, etc.
local STARTING_Z = 0  -- 0 is a block just outside the "zone", 1 is 1st block inside, 2 is 2nd, etc.

-- Initialize variables.
local current_X = STARTING_X
local current_Y = STARTING_Y
local current_Z = STARTING_Z
local h  -- For use by log file functions.
local t  -- Variable shortcut, typically for 'text'.

--endregion

--region F
-- ###################################  
--              FUNCTIONS
-- ###################################

local function startLogFile ()
    -- Create or open existing log file.
    h = fs.open("logFile", fs.exists("logFile") and "a" or "w")
    t = "********** Program started. **********"
    --
    print(t)
    h.writeLine(t)
    h.flush()
end

local function stopLogFile ()
    -- Close the open log file; assumes variable for file is named 'h.'
    t = "---------- Program ended. ------------"
    print(t)
    h.writeLine(t)
    print("")
    h.writeLine("")
    h.flush()
    --
    h.close()
end

local function reportStatusToLog (statusMsg)
    -- Write to the open log file and screen; assumes variable for file is named 'h.'
    print(statusMsg)
    h.writeLine(statusMsg)
    h.flush()
end

local function trackMovement (action)
    -- Edit, manage, and report turtle's position in 3D space, e.g., relative XYZ coordinates from origin of "zone".
    --reportStatusToLog("The trackMovement() function started.")

    local enableReportingOfMovement = false
    if action == "positiveX_Movement" then
        current_X = current_X + 1
        enableReportingOfMovement = true
    elseif action == "negativeX_Movement" then
        current_X = current_X - 1
        enableReportingOfMovement = true
    elseif action == "positiveY_Movement" then
        current_Y = current_Y + 1
        enableReportingOfMovement = true
    elseif action == "negativeY_Movement" then
        current_Y = current_Y - 1
        enableReportingOfMovement = true
    elseif action == "resetY_ToGround" then
        reportStatusToLog("Resetting Y to ground level, i.e., 1.")
        current_Y = 1
        enableReportingOfMovement = true
    elseif action == "positiveZ_Movement" then
        current_Z = current_Z + 1
        enableReportingOfMovement = true
    elseif action == "negativeZ_Movement" then
        current_Z = current_Z - 1
        enableReportingOfMovement = true
    elseif action == nil then 
        print(" - Usage notes: ")
        print("     trackMovement(action) ")
        print(" - A single argument is required.")
        print(" - Example string arguments:")
        print("    'positiveX_Movement', ")
        print("    'negativeY_Movement', ")
        print("    etc.")
    else
        reportStatusToLog(time .. " - There was an error. [trackMovement]")
    end

    if enableReportingOfMovement == true then
        local time = os.clock()
        local str = current_X .. " " .. current_Y .. " " .. current_Z .. " [trackMovement]" .. " [" .. time .. "]"
        reportStatusToLog(str)
    end
    --reportStatusToLog("The trackMovement() function ended.")
end

local function ascendUp (distance)
    --reportStatusToLog("The ascendUp (distance) function started.")
    t = "    Moving up... Step "
    for i = 1, distance do
        turtle.digUp()  -- just in case there's a block above the turtle
        turtle.up()
        trackMovement("positiveY_Movement")
    end
    --reportStatusToLog("  The ascendUp (distance) function ended.")
end

local function digAndMoveDownOnce ()
    --reportStatusToLog("The digAndMoveDownOnce() function started.")
    turtle.digDown()
    turtle.down()
    trackMovement("negativeY_Movement")
    --reportStatusToLog("The digAndMoveDownOnce() function ended.")
    -- TODO: Consider feature that will avoid digging when block is air.
end

local function digAndMoveForwardOnce (movementData)
    -- About movementData: Indicates whether forward movement should be 
    --   considered as moving along the X or Z axis, as well as 
    --   whether to record it as a positive or negative movement, e.g., 
    --   "positiveZ_Movement". Allowable options listed in the 
    --   trackMovement() definition.
    turtle.dig()
    turtle.forward()
    trackMovement(movementData)
end

local function turnOneEighty ()
    turtle.turnLeft()
    turtle.turnLeft()
end

local function returnToFirstColumn ()
    -- TODO: Verify that "negativeZ_Movement" will always be the
    --   argument. If not, edit the function to accomodate other options.
    turnOneEighty()
    for i = 1, (MAX_Z - 1) do   -- Z is forward/backward
        digAndMoveForwardOnce("negativeZ_Movement")
    end
end

local function maybePlantASapling ()
    -- Maybe plant a sapling from Slot 1.
    local blockDoesExist, blockInfo = turtle.inspectDown()
    local randomPlanting = math.random(10)  -- 1 is 100% (1/1) chance; 2 is 50% (1/2); 10 is 10% (1/10); etc.
    if randomPlanting == 1 and blockInfo.tags["forge:dirt"] then
      turtle.select(1)
      turtle.up() 
      trackMovement("positiveY_Movement")
      turtle.placeDown()
      reportStatusToLog("Attempted to plant sapling from Slot 1.")
    else
        reportStatusToLog("Criteria was not met to plant a sapling.")
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
    -- TODO:FIX: Find a way to handle other kinds of blocks that may be in the way, e.g., wool, beehives.
    --  Use blockInfo.tags["forge:dirt"] to confirm at the ground? Add a list of non-diggable items in ground, e.g., flowers, grass?
    else
        for i = 1, 4 do
            turtle.suck()
            turtle.turnLeft()
        end
        maybePlantASapling()
        trackMovement("resetY_ToGround")
    end
    --reportStatusToLog("  The decendToGround() function ended.")
  end

local function processColumn()
    -- If columns *do* remain in current slice, go to next column.
    if current_Z < MAX_Z then
        ascendUp(MAX_Y - 1)  
            -- Y is up/down;
            -- Height argument == Zone height minus turtle's own height
        digAndMoveForwardOnce("positiveZ_Movement")
        decendToGround()
    -- If columns do *not* remain in current slice, go back to first column.
    elseif current_Z == MAX_Z then
        ascendUp(MAX_Y - 1)
        returnToFirstColumn()
        decendToGround()
    else
        reportStatusToLog("Some sort of error occurred while processing column(s).")
    end
end

local function processSlice ()
    for i = 1, MAX_Z do  -- Z is forward/backward
        processColumn()
    end
end

local function goToNextSlice ()

    -- If slices *do* remain in zone, go to next slice.
    if current_X < MAX_X then  -- X is side-to-side, left/right
        turtle.turnLeft()
        digAndMoveForwardOnce("positiveX_Movement")
        turtle.turnLeft()
    
    -- If slices do *not* remain in zone, go back to first slice:
    elseif current_X == MAX_X then
        ascendUp(MAX_Y)
        turtle.turnRight()
        for i = 1, (MAX_X - 1) do 
            digAndMoveForwardOnce("negativeX_Movement")
        end
        turtle.turnRight()
        decendToGround()
    
    else
        reportStatusToLog("Some sort of error occurred while processing slice(s).")
    end
end

--endregion

--region M
-- ###################################  
--              MAIN CODE
-- ###################################

do
    startLogFile()
    repeat
        reportStatusToLog("Starting new iteration of REPEAT loop...")
        reportStatusToLog("  Will run until current_X == MAX_X.")
        reportStatusToLog("  current_X == " .. current_X)
        reportStatusToLog("  MAX_X == " .. MAX_X)
        processSlice()
        -- < add some GO DOWN code here? >
        goToNextSlice()
    until current_X == MAX_X
    processSlice()
    goToNextSlice()  -- This should cause turtle to return to first slice.
    reportStatusToLog("REPEAT loop has ended.")
    stopLogFile()
end



--region O
-- ###################################
--              OLD CODE
-- ###################################

local function z_OLD_processColumn ()
--[[  TODO: Split this one fuction into 2+ simpler functions? ]]--
--[[  Combine with / compare to zoneGo() & goToNextColumn().  ]]--
--
    -- NOTE: Removed columnHeight parameter from function (EJM, 2021-04-18).
    --reportStatusToLog("The processColumn() function started.")
    local blockInfo = {}  -- Contains inspection info for a block
    digAndMoveDownOnce()
    if turtle.inspectDown() == false then  -- 'False' indicates air.
        processColumn()  -- Recursive call
    else
        local doesExist, blockInfo = turtle.inspectDown()
        if blockInfo.tags["minecraft:leaves"] or blockInfo.tags["minecraft:logs"] or blockInfo.tags["minecraft:saplings"] then
            processColumn()  -- Recursive call
        -- Otherwise, assume block is ground or non-diggable item...
        else
            -- TODO: Perform suck() only if previous block was wood?
            for i = 1,4 do
                turtle.suck()
                turtle.turnLeft()
            end
            maybePlantASapling()
        end
    end
    --reportStatusToLog("  The processColumn() function ended.")
end

local function z_OLD_goToNextColumn()
--[[  TODO: Split this one fuction into 2+ simpler functions? ]]--
--[[  Combine with / compare to zoneGo() & processColumn ().  ]]--
--
    --reportStatusToLog("The goToNextColumn() function started.")
    if current_Z < MAX_Z then
        zoneGo("enter")
    else
        ascendUp(MAX_Y)
        -- "Back up" by turning 180, moving forward, then turning 180 again.
        turtle.turnLeft()
        turtle.turnLeft()
        for i = 1, MAX_Z do
            turtle.dig()   -- just in case there's a block in front of turtle
            turtle.forward()
            trackMovement("negativeZ_Movement")
        end
        turtle.turnLeft()
        turtle.turnLeft()
    end
    --reportStatusToLog("  The goToNextColumn() function ended.")
end

local function z_OLD_zoneGo(direction)
    --[[  TODO: Split this one fuction into 2+ simpler functions? ]]--
    --[[  Combine with / compare to processColumn() & goToNextColumn().  ]]--
    --
        --reportStatusToLog("The zoneGo() function started.")
        if direction == "enter" then
            -- Enter the zone.
            ascendUp(MAX_Y - current_Y)
            turtle.dig()  -- just in case there's a block in front of turtle
            turtle.forward()
            trackMovement("positiveZ_Movement")
        elseif direction == "exit" then
            -- Exit the zone.
            turtle.turnLeft()
            turtle.turnLeft()
            turtle.dig()   -- just in case there's a block in front of turtle
            turtle.forward()
            trackMovement("negativeZ_Movement")
            turtle.turnLeft()
            turtle.turnLeft()
            decendDown(MAX_Y + 1)
        else
            -- Do nothing.
        end
            --reportStatusToLog("  The zoneGo() function ended.")
end

local function z_OLD_goToNextSlice ()
    --reportStatusToLog("The goToNextSlice() function started.")
    if current_X > MAX_X then
        turtle.turnRight()
        turtle.dig()  -- just in case there's a block in front of turtle
        turtle.forward()
        trackMovement("positiveX_Movement")
        turtle.turnLeft()
    else
        turtle.turnLeft()
        for i = 1, (MAX_X - 1) do
            turtle.dig()  -- just in case there's a block in front of turtle
            turtle.forward()
            trackMovement("negativeX_Movement")
        end
        turtle.turnRight()
    end
    --reportStatusToLog("  The goToNextSlice() function ended.")
end

local function z_OLD_decendDown (distance)
    --reportStatusToLog("The descendDown (distance) function started.")
    t = "    Moving down... Step "
    for i = distance, 1, -1 do
        turtle.digDown()  -- just in case there's a block below the turtle
        turtle.down()
        trackMovement("negativeY_Movement")
    end
    --reportStatusToLog("  The descendDown (distance) function ended.")
end

--[[     
    zoneGo("enter")
    for j = 1l MAX_X do
        reportStatusToLog("j == " .. j)
        for i = 1, MAX_Z do
            reportStatusToLog("i == " .. i)
            reportStatusToLog("Processing column...")
            processColumn()  -- TODO: Verify that parameter needs to be part of function.
            reportStatusToLog("Going to next column...")
            goToNextColumn()
        end
        reportStatusToLog("Going to next slice...")
        goToNextSlice()
        reportStatusToLog("Entering zone during MIDDLE of program.")
        zoneGo("enter")
    end
    -- TODO: Add code here to move turtle back to first column?
    reportStatusToLog("Exiting zone near END of program.")
    zoneGo("exit") 
  ]]


--endregion--

--endregion

--region N
-- ###################################  
--              FOOTNOTES
-- ###################################
--[[

1.  Author is EJ Makela; start date was sometime in 2021-03.

2.  About <<doesExist, blockInfo = turtle.inspectDown()>> and <<blockInfo.tags == nil>>:
    - When block below is air, inspectDown will return 'false'.
    - If seeking for value of a tag in a block's metadata table, *and* that block is air, the return value will be 'nil'.

3. 

]]
--endregion--
