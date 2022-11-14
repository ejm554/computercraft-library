--[[

Script Created by CEEBS
YouTube: https://www.youtube.com/c/OriginalCEEBS
Twitter: https://twitter.com/OnlyCeebs

Really appreciate all the support you have given me, so thank you!

-----------------------------------------------------------------

I'll be interested to see any modifications made, so please feel free to let me know what you've come up with. Happy coding, happy gaming. Peace!

One little issue with the checkFuelLevel and refuel function. The script may refuse to run after refueling, just run the script again and it'll be fine. Please feel free to troubleshoot, not a difficult fix, will just require some conditional logic.

]]--

-- Receive arguments and perform some basic validation
local height = 0
local width = 0
local depth = 0

if #arg == 3 then
    height = tonumber(arg[1])
    width = tonumber(arg[2])
    depth = tonumber(arg[3])

    if width % 2 == 0 or height % 2 == 0 then
        print("Both the height and width arguments must be an odd number")
        return
    elseif width == 1 or height == 1 then
        print("Both the height and width arguments must be greater and 1")
        return
    end
else
    print("Please enter the correct arguments when executing this script. The height width and depth are required (e.g. mining 5 5 10)")
    return
end

local INVENTORY_SIZE = 16
local heightMovement = math.floor(height / 2)
local widthMovement = math.floor(width / 2)

-- List of accepted fuels
local ACCEPTED_FUELS = {
    "minecraft:coal_block",
    "minecraft:coal"
}

-- List of whitelisted items
local ACCEPTED_ITEMS = {
    "minecraft:coal",
    "minecraft:iron_ore",
    "minecraft:gold_ore",
    "minecraft:redstone",
    "minecraft:diamond",
    "minecraft:emerald",
    "minecraft:dye",
    "thermalfoundation:ore",
    "appliedenergistics2:material",
    "tconstruct:ore",
}

-- Perform inventory check
function inventoryCheck()
    
    -- Check for rubbish items
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            local isAcceptedItem = false
            for x = 1, #ACCEPTED_ITEMS do
                if currentItem.name == ACCEPTED_ITEMS[x] then
                    isAcceptedItem = true
                end
            end
            if not isAcceptedItem then
                turtle.select(i)
                turtle.dropUp()
            end
        end
    end

    -- Group items together
    for j = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(j)

        if currentItem ~= nil then
            turtle.select(j)
            for k = j, INVENTORY_SIZE do
                if turtle.compareTo(k) then
                    turtle.select(k)
                    turtle.transferTo(j)
                    turtle.select(j)
                end
            end
        end
    end
end

-- Refuel using the found fuel
function refuel(slot_number)
    print("[TURTLE] Refueling... ")
    turtle.select(slot_number)
    turtle.refuel()
    print("[TURTLE] Nom. Nom. Nom.")
end

-- Check the current fuel level
function checkFuelLevel()
    local requiredFuelLevel = math.ceil((height * width * depth) + (heightMovement + widthMovement))
    local currentFuelLevel = turtle.getFuelLevel()

    print("[TURTLE] Current fuel level is: "..currentFuelLevel.." - Required: "..requiredFuelLevel)

    if currentFuelLevel < requiredFuelLevel then

        print("[TURTLE] Attempting to locate fuel.")

        for i = 1, INVENTORY_SIZE do
            local currentItem = turtle.getItemDetail(i)
            if currentItem ~= nil then
                for x = 1, #ACCEPTED_FUELS do
                    if currentItem.name == ACCEPTED_FUELS[x] then
                        print("[TURTLE] Acceptable fuel found: " ..ACCEPTED_FUELS[x])

                        if currentFuelLevel < requiredFuelLevel then
                            refuel(i)
                        else
                            return true
                        end
                    end
                end
            end
        end
        print("[TURTLE] No acceptable fuel or not enough found, terminating program...")
        return false
    else
        return true
    end
end

-- Combat gravel/sand
function moveUpAndDig()
    while turtle.up() == false do
        turtle.digUp()
    end
end

function moveForwardAndDig()
    while turtle.forward() == false do
        turtle.dig()
    end
end

function moveDownAndDig()
    while turtle.down() == false do
        turtle.digDown()
    end
end

-- Move to start position
function moveToStartPosition()
    
    -- Move to horizontal start position
    turtle.turnLeft()
    for i = 1, widthMovement do
        moveForwardAndDig()
    end
    turtle.turnRight()

    -- Move to vertical start postion
    for i = 1, heightMovement do
        moveUpAndDig()
    end

end

-- Mining Sequence
function mineSequence()

    moveToStartPosition()

    for x = 1, depth do
    
        moveForwardAndDig()

        for i = 1, height do

            if x % 2 == 0 then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end

            for y = 1, width - 1 do
                moveForwardAndDig()
            end

            if i ~= height then
                if x % 2 == 0 then
                    turtle.turnLeft()
                    moveUpAndDig()
                else
                    turtle.turnRight()
                    moveDownAndDig()
                end
            end

        end

        if x % 2 == 0 then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end

        inventoryCheck()

    end

end

if checkFuelLevel() then
    mineSequence()
end