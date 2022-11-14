-- Use seeds in inventory in a 
--  composter under the turtle,
--  and collect the resulting bone
--  meal.

local currentSlot = 1
local INVENTORY_SIZE = 16

-- List of accepted, compostable items
local ACCEPTED_ITEMS = {
    "minecraft:beetroot_seeds",
    "minecraft:wheat_seeds",
    "minecraft:pumpkin_seeds",
    "minecraft:melon_seeds",
}

local function doesContainAcceptedItems()
    for j = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(j)
        if currentItem ~= nil then
            for x = 1, #ACCEPTED_ITEMS do
                if currentItem.name == ACCEPTED_ITEMS[x] then
                    return true, "The turtle DOES contain one or more accepted items."
                end
            end
        end
    end
    return false, "The turtle does NOT contain any accepted items."
end

local function groupInventoryItems()
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

local function transferCompostableItems()
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            local isAcceptedItem = false
            for x = 1, #ACCEPTED_ITEMS do
                if currentItem.name == ACCEPTED_ITEMS[x] then
                    isAcceptedItem = true
                end
            end
            if isAcceptedItem then
                turtle.select(i)
                turtle.drop()
            end
        end
        
    end
end

local function isHopperInFront()
    local blockDoesExist, blockInfo = turtle.inspect()
    if blockInfo.name == "minecraft:hopper" then
        return true --, "A hopper WAS found in front of the turtle."
    else
        return false --, "A hopper was NOT found in front of the turtle."
    end
end

local function isChestDownBelow()
    local blockDoesExist, blockInfo = turtle.inspectDown()
    if blockInfo.name == "minecraft:chest" then
        return true
    else
        return false
    end
end

local function transferBonemeal()
    for i = 1, INVENTORY_SIZE do
        --local currentItem = turtle.getItemDetail(i)
        --if currentItem == "minecraft:bonemeal" then
            --turtle.select(j)
            turtle.suckDown()
        --end
    end
end

---------------
-- MAIN CODE --
---------------
print("---- PROGRAM STARTED ----")
print("Grouping inventory items...")
groupInventoryItems()

if isHopperInFront() == true then
    print("Hopper in front...")
    print("Transferring compostable items...")
    transferCompostableItems()
else
    print("It appears that there isn't a hopper in front of the turtle. Hmmm...")
end

print("Turtle moving down to chest...")
turtle.down()
write("Please wait while bonemeal is being produced...")
for i = 1, 60 do 
    os.sleep(1)
    write(".")
end 

if isChestDownBelow() == true then
    --print("Transferring bonemeal from chest...")
    --transferBonemeal()
    print("Going back to start position...")
    turtle.up()
else
    print("It appears that there isn't a chest below the turtle. Hmmm...")
end

print("Grouping inventory items (again)...")
groupInventoryItems()

print("**** PROGRAM ENDED ****")
print("") -- dislays a blank line for readability

---------------
-- FOOTNOTES --
---------------
--[[

- Portions of this code was adapted from CCTurtleMining.lua written by CEEBS.

]]
