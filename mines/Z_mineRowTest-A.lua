--------------------------------------
-- Mines a zone of blocks.
-- See footnotes for add'l detail.
--------------------------------------

--region I
-- ###################################  
--          INITIALIZATIONS
-- ###################################

-- Initialize constants.
local MAX_RELATIVE_X = 10  -- Side-to-side, "slices", relative to an origin in a 3D "zone" of trees
local MAX_RELATIVE_Y = 10  -- Up-to-down, relative to origin of "zone"
local MAX_RELATIVE_Z = 8  -- Forward-to-back, "columns", relative to origin of "zone"
--
local MAIN_FORWARD_DIRECTION  -- For future use. Example: "East"
--
-- Initialize variables.
local relativeX = 1  -- 1 is 1st slice (leftmost side), 2 is on 1's immediate right, etc.
local relativeY = 1  -- 0 is just below ground, 1 is ground level, 2 is next block up, etc.
local relativeZ = 0  -- 0 is a block just outside the "zone", 1 is 1st block inside, 2 is 2nd, etc.
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


local function trackMovement (directionOfMovement)
    -- Edit, manage, and report turtle's position in 3D space, e.g., relative XYZ coordinates from origin of "zone".
    --reportStatusToLog("The trackMovement() function started.")

    local time = os.clock()
    local str = time .. " - " .. relativeX .. " " .. relativeY .. " " .. relativeZ .. " [trackMovement]"

    if directionOfMovement == "positiveX_Movement" then
        relativeX = relativeX + 1
        reportStatusToLog(str)
    elseif directionOfMovement == "negativeX_Movement" then
        relativeX = relativeX - 1
        reportStatusToLog(str)
    --    
    elseif directionOfMovement == "positiveY_Movement" then
       relativeY = relativeY + 1
       reportStatusToLog(str)
    elseif directionOfMovement == "negativeY_Movement" then
        relativeY = relativeY - 1
        reportStatusToLog(str)
    --
    elseif directionOfMovement == "positiveZ_Movement" then
        relativeZ = relativeZ + 1
        reportStatusToLog(str)
    elseif directionOfMovement == "negativeZ_Movement" then
        relativeZ = relativeZ - 1
        reportStatusToLog(str)
    
    elseif directionOfMovement == nil then 
        print(" - Usage notes: ")
        print("     trackMovement(directionOfMovement) ")
        print(" - A single argument is required.")
        print(" - Example string arguments:")
        print("    'positiveX_Movement', ")
        print("    'negativeY_Movement', ")
        print("    etc.")
    
    else
        reportStatusToLog(time .. " - There was an error. [trackMovement]")
    end        

    --reportStatusToLog("The trackMovement() function ended.")
end    


local function ascendUp (columnHeight)
    reportStatusToLog("The ascendUp (columnHeight) function started.")
    t = "    Moving up... Step "
    for i = 1, columnHeight do
        turtle.digUp()  -- just in case there's a block above the turtle
        turtle.up()
        trackMovement("positiveY_Movement")
        --reportStatusToLog(t .. i)
    end
    reportStatusToLog("  The ascendUp (columnHeight) function ended.")
end


local function decendDown (columnHeight)
    reportStatusToLog("The descendDown (columnHeight) function started.")
    t = "    Moving down... Step "
    for i = columnHeight, 1, -1 do
        turtle.digDown()  -- just in case there's a block below the turtle
        turtle.down()
        trackMovement("negativeY_Movement")
        --reportStatusToLog(t .. i)
    end
    reportStatusToLog("  The descendDown (columnHeight) function ended.")
end


local function digAndMoveDownOnce ()
    reportStatusToLog("The digAndMoveDownOnce() function started.")
    turtle.digDown()
    turtle.down()
    trackMovement("negativeY_Movement")
    reportStatusToLog("  The digAndMoveDownOnce() function ended.")
    -- TODO: Consider feature that will avoid digging when block is air.
end


--[[  TODO: Split this one fuction into 2+ simpler functions? ]]--
--[[  Combine with / compare to processColumn() & goToNextColumn().  ]]--
local function zoneGo(direction)
    reportStatusToLog("The zoneGo() function started.")
    reportStatusToLog("    [zoneGo] Before: relativeZ == " .. relativeZ .. " (1)")
    
    if direction == "enter" then
        -- Enter the zone.
        reportStatusToLog("    [zoneGo] Calling ascendUp().")
        ascendUp(MAX_RELATIVE_Y - relativeY)
        reportStatusToLog("    [zoneGo] Control passed back to zoneGo().")
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
        reportStatusToLog("    [zoneGo] Calling decendDown().")
        decendDown(MAX_RELATIVE_Y)
        reportStatusToLog("    [zoneGo] Control passed back to zoneGo().")

    
    else
        -- Do nothing?
    
    end
    reportStatusToLog("    [zoneGo] After: relativeZ == " .. relativeZ .. " (2)")
    reportStatusToLog("  The zoneGo() function ended.")

end

--[[  TODO: Split this one fuction into 2+ simpler functions? ]]--
--[[  Combine with / compare to zoneGo() & goToNextColumn().  ]]--
--
local function processColumn (columnHeight)

    reportStatusToLog("The processColumn() function started.")
    --local blockInfo = {}  -- Contains inspection info for a block
    
    for j = 1, columnHeight do
        digAndMoveDownOnce()
    end
    -- if turtle.inspectDown() == false then
    --     processColumn(columnHeight)  -- Recursive call
    -- else    
    --     _, blockInfo = turtle.inspectDown()
        
    --     if blockInfo.tags["minecraft:leaves"] or blockInfo.tags["minecraft:logs"] then
    --         --digAndMoveDownOnce()
    --         processColumn(columnHeight)  -- Recursive call
    --     -- Otherwise, assume block is ground or non-diggable item...
    --     else
    --         for i = 1,4 do
    --             turtle.suck()
    --             turtle.turnLeft()
    --         end
    --     end
    
    -- end
    --
    -- TODO: **FIX:** Turtle should *not* move up after BREAK if blockInfo.tags == nil.
    -- 4. Move upward by columnHeight, e.g., 15 blocks.
    --
    reportStatusToLog("  The processColumn() function ended.")
end



--[[  TODO: Split this one fuction into 2+ simpler functions? ]]--
--[[  Combine with / compare to zoneGo() & processColumn ().  ]]--
local function goToNextColumn()
    reportStatusToLog("The goToNextColumn() function started.")

    if relativeZ < MAX_RELATIVE_Z then

        -- Move up full height, then one block forward.
        reportStatusToLog("    [goToNextColumn] Calling zoneGo('enter').")
        zoneGo("enter")
        reportStatusToLog("    [goToNextColumn] Control passed back to goToNextColumn().")
        --relativeZ = relativeZ + 1

    else

        reportStatusToLog("    [goToNextColumn] No additional columns in this slice; Returning to first column...")
        reportStatusToLog("    [goToNextColumn] Calling ascendUp(MAX_RELATIVE_Y).")
        ascendUp(MAX_RELATIVE_Y)
        reportStatusToLog("    [goToNextColumn] Control passed back to goToNextColumn().")

        -- "Back up" by turning 180, moving forward, then turning 180 again.
        turtle.turnLeft()
        turtle.turnLeft()
        for i = 1, MAX_RELATIVE_Z do
            reportStatusToLog("    [goToNextColumn] Backing up from Position " .. relativeZ .. "...")
            turtle.dig()   -- just in case there's a block in front of turtle
            turtle.forward()
            trackMovement("negativeZ_Movement")
            --relativeZ = relativeZ - 1
            reportStatusToLog("    [goToNextColumn] Now at Position " .. relativeZ .. ".")
        end
        turtle.turnLeft()
        turtle.turnLeft()

    end

    reportStatusToLog("  The goToNextColumn() function ended.")
end


local function goToNextSlice()
    reportStatusToLog("The goToNextSlice() function started.")
    
    if relativeX < MAX_RELATIVE_X then
        reportStatusToLog("    [goToNextSlice] Moving right from Position " .. relativeX .. "...")
        turtle.turnRight()
        turtle.dig()  -- just in case there's a block in front of turtle
        turtle.forward()
        trackMovement("positiveX_Movement")
        --relativeX = relativeX + 1
        turtle.turnLeft()
        reportStatusToLog("    [goToNextSlice] Now at Position " .. relativeX .. ".")

    
    else
        reportStatusToLog("    [goToNextSlice] No additional slices in the zone.")
        turtle.turnLeft()
        for i = 1, (MAX_RELATIVE_X - 1) do
            reportStatusToLog("    [goToNextSlice] Moving left from Position " .. relativeX .. "...")
            turtle.dig()  -- just in case there's a block in front of turtle
            turtle.forward()
            trackMovement("negativeX_Movement")
            --relativeX = relativeX - 1
            reportStatusToLog("    [goToNextSlice] Now at Position " .. relativeX .. ".")
        end
        turtle.turnRight()
    
    end
    
    reportStatusToLog("  The goToNextSlice() function ended.")
end

--endregion



--region M
-- ###################################  
--              MAIN CODE
-- ###################################

do
    startLogFile()
    zoneGo("enter")
    for j = 1, MAX_RELATIVE_X do
        for i = 1, MAX_RELATIVE_Z do
            processColumn(MAX_RELATIVE_Y)  -- TODO: Verify that parameter needs to be part of function.
            goToNextColumn()
        end
        goToNextSlice()
        zoneGo("enter")
    end
    -- TODO: Add code here to move turtle back to first column?
    zoneGo("exit")
    stopLogFile()
end

--endregion--



--region F
-- ###################################  
--              FOOTNOTES
-- ###################################
--[[

1.  Author is EJ Makela; start date was sometime in 2021-04.

2.  About <<_, blockInfo = turtle.inspectDown()>> and <<blockInfo.tags == nil>>:
    - When block below is air, inspectDown will return 'false'.
    - If seeking for value of a tag in a block's metadata table, *and* that block is air, the return value will be 'nil'.

3. 

]]
--endregion--
