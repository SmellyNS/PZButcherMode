-- Функция для добавления опции в контекстное меню
local function addButcherZombieOption(player, context, worldObjects, test)
    print("ZombieButcher: context type = ", type(context), ", value = ", context)
    print("ZombieButcher: worldObjects type = ", type(worldObjects), ", val = ", worldObjects)
    print("ZombieButcher: player type = ", type(player), ", value = ", player)
    local playerObj = getSpecificPlayer(player)
    local inventory = playerObj:getInventory()

    -- Проверяем, есть ли среди объектов на земле труп зомби
    local corpse = nil
    print("Starting searching for corpse")
    for _, obj in ipairs(worldObjects) do
        print("There is ", obj:getSprite():getName())
        if obj:getSprite() and (obj:getSprite():getName() == "Base.CorpseMale" or obj:getSprite():getName() == "Base.CorpseFemale") then
            corpse = obj
            print("FOUND!")
            break
        end
    end
    print("CORPSE OBJ = ", corpse)

    if not corpse then
        local x, y, z = playerObj:getX(), playerObj:getY(), playerObj:getZ()
        local square = getCell():getGridSquare(x, y, z)
        if square then
            local objects = square:getObjects()
            for i = 0, objects:size() - 1 do
                local obj = objects:get(i)
                if instanceof(obj, "IsoDeadBody") then
                    corpse = obj
                    print("ZombieButcher: Found IsoDeadBody in square at ", x, ", ", y, ", ", z)
                    break
                end
                print(obj:getSprite():getName())
            end
        else
            print("ZombieButcher: No square found at ", x, ", ", y, ", ", z)
        end
    end

    if not corpse then
        local deadBodies3 = getWorld()
        local deadBodies2 = deadBodies3:getCell()
        local x, y, z = playerObj:getX(), playerObj:getY(), playerObj:getZ()
        local deadBodies1 = deadBodies2:getGridSquare(x,y,z)
        local deadBodies = deadBodies1:getDeadBodys()

        if deadBodies then
            print("ZombieButcher: Checking ", deadBodies:size(), " objects in world")
            for i = 0, deadBodies:size() - 1 do
                local body = deadBodies:get(i)
                print("There is a possible dead body: ", body)
                if instanceof(body, "IsoDeadBody") then
                    print("ZombieButcher: Found IsoDeadBody. Checking if its human-like")
                    print("isZombie = ", body:isZombie())
                    print("isSkeleton = ", body:isSkeleton())
                    print("isPlayer = ", body:isPlayer())
                    local condition = body:isZombie() or body:isSkeleton() or body:isPlayer()
                    print("isZombie = ", body:isZombie())
                    print("isSkeleton = ", body:isSkeleton())
                    print("isPlayer = ", body:isPlayer())
                    if condition then
                        print("This is THE body! ")
                        corpse = body
                    end
                end
            end
        else
            print("ZombieButcher: No DeadBodies in world")
        end
    end


    -- Если найден труп, проверяем наличие инструмента и навыка
    if corpse then
        print("THERE IS CORPSE")
        -- Проверяем, есть ли у игрока предмет с тегом SharpKnife или MeatCleaver
        local hasTool = false
        local items = inventory:getItems()
        for i = 0, items:size() - 1 do
            local item = items:get(i)
            if item:hasTag("SharpKnife") or item:hasTag("MeatCleaver") then
                hasTool = true
                break
            end
        end
        print("DO I HAVE A TOOL? ",hasTool)

        if hasTool then
            context:addOption(getText("Butcher human corpse"), corpse, onButcherZombie, playerObj)
        end
    end
end

-- Функция, вызываемая при выборе опции "Butcher Zombie"
function onButcherZombie(corpse, playerObj)
    ISTimedActionQueue.add(ISButcherZombieAction:new(playerObj, corpse))
end

-- Подписываемся на событие контекстного меню
Events.OnFillWorldObjectContextMenu.Add(addButcherZombieOption)