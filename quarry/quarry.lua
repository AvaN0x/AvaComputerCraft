local width = 14 -- only even
local depth = 14

local function tryDigForward()
    if turtle.detect() then
        if not turtle.dig() then
            error("I got stuck in tryDigForward()")
        end
        turtle.suck()
    end
end

local function tryDigDown()
    if turtle.detectDown() then
        if not turtle.digDown() then
            error("I got stuck in tryDigDown()")
        end
        turtle.suckDown()
    end
end

local function tryDigUp()
    if turtle.detectUp() then
        if not turtle.digUp() then
            error("I got stuck in tryDigUp()")
        end
        turtle.suckUp()
    end
end

local function moveForward()
    while not turtle.forward() do
        turtle.attack()
        os.sleep(1)
    end
end

local function moveDown()
    while not turtle.down() do
        turtle.attackDown()
        os.sleep(1)
    end
end

local function moveUp()
    while not turtle.up() do
        turtle.attackUp()
        os.sleep(1)
    end
end

local function refuelFull()
    term.setTextColor(colors.yellow)
    print("Actual fuel level : " .. turtle.getFuelLevel())
    turtle.turnLeft()
    -- TODO take enought to go up and down, and do the line
    while turtle.getFuelLevel() <= 300  do
        turtle.suck(1)
        local worked, errorString = turtle.refuel(1)
        if not worked then
            turtle.turnRight()
            error(errorString)
        end
    end
    turtle.turnRight()
    print("Fuel level after refuel : " .. turtle.getFuelLevel())
    term.setTextColor(colors.white)
end

local function dropAllItems()
    turtle.turnLeft()
    turtle.turnLeft()
    for i = 1, 16, 1 do -- 16 slots
        turtle.select(i)
        turtle.drop()
    end
    turtle.turnRight()
    turtle.turnRight()
end

local function quarryLine()
    for i=1, width, 1 do
        for j=1, depth - 1, 1 do
            tryDigForward()
            moveForward()
        end

        if i ~= width then
            if i % 2 == 1 then
                turtle.turnRight()
                tryDigForward()
                moveForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                tryDigForward()
                moveForward()
                turtle.turnLeft()
            end
        end
    end
    if width % 2 == 1 then
        turtle.turnRight()
        turtle.turnRight()
        for j=1, depth - 1, 1 do
            tryDigForward()
            moveForward()
        end
    end
    turtle.turnRight()
    for j=1, width - 1, 1 do
        tryDigForward()
        moveForward()
    end
    turtle.turnRight()
end

local function digLineAtHeight(height)
    for j=1, height, 1 do
        tryDigDown()
        moveDown()
    end
    quarryLine()
    for j=1, height, 1 do
        tryDigUp()
        moveUp()
    end
end

local height = 0
local startPos = vector.new(gps.locate(5)) -- x, y, z
if startPos.y ~= 0 then
    height = startPos.y - 6
else
    height = 2
end

if height > 0 then
    print("Height to mine : " .. height)
    dropAllItems()
    for i=1, height, 1 do
        refuelFull()

        term.setTextColor(colors.green)
        print("Now mining height y = y-" .. i)
        term.setTextColor(colors.white)

        digLineAtHeight(i)
        dropAllItems()
    end
else
    error("Height is negative or null.")
end
