require "TimedActions/LuaTimedActionNew"

ISButcherZombieAction = LuaTimedActionNew:derive("ISButcherZombieAction")

function ISButcherZombieAction:isValid()
    if not self.corpse or not self.corpse:getSquare() or not instanceof(self.corpse, "IsoDeadBody") then
        print("ISButcherZombieAction: Invalid corpse")
        return false
    end
    if not self.character or not instanceof(self.character, "IsoPlayer") then
        print("ISButcherZombieAction: Invalid character")
        return false
    end
    local inventory = self.character:getInventory()
    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item:hasTag("SharpKnife") or item:hasTag("MeatCleaver") then
            return true
        end
    end
    print("ISButcherZombieAction: No suitable knife found")
    return false
end

function ISButcherZombieAction:start()
    self:setAnim("SliceMeat_Surface")
    if self.character and self.corpse then
        self.character:faceThisObject(self.corpse)
    end
    self.sound = getSoundManager():PlayWorldSound("PutItemInBag", self.corpse:getSquare(), 0, 10, 1, false)
end

function ISButcherZombieAction:update()
    if self.character and self.corpse then
        self.character:faceThisObject(self.corpse)
    end
end

function ISButcherZombieAction:stop()
    if self.sound then
        self.sound:stop()
    end
    LuaTimedActionNew.stop(self)
end

function ISButcherZombieAction:perform()
    print("ISButcherZombieAction: Starting perform")
    if not self:isValid() then
        print("ISButcherZombieAction: Action is invalid in perform")
        LuaTimedActionNew.stop(self)
        return
    end

    -- Останавливаем звук
    if self.sound then
        print("ISButcherZombieAction: Stopping sound")
        self.sound:stop()
    end

    -- Добавляем предметы в инвентарь
    print("ISButcherZombieAction: Adding items to inventory")
    local inventory = self.character:getInventory()
    local trappingLevel = self.character:getPerkLevel(Perks.Trapping)
    local meatCount = ZombRand(1, 3)
    local fatCount = ZombRand(1, 3)
    local boneCount = ZombRand(1, 3)
    local debug1 = 0
    for i = 1, math.floor(meatCount + trappingLevel * 0.5) do
        inventory:AddItem("ZombieButcher.HumanMeat")
    end
    for i = 1, math.floor(fatCount + trappingLevel * 0.5) do
        inventory:AddItem("ZombieButcher.Fat")
    end
    for i = 1, math.floor(boneCount + trappingLevel * 0.5) do
        inventory:AddItem("ZombieButcher.BoneFlour")
        debug1 = debug1 + 1
        inventory:AddItem("Base.SmallAnimalBone")
    end

    -- Выводим сообщение
    print("ISButcherZombieAction: Saying message")
    local debug2 = 0

    self.character:Say("I butchered the corpse.")
    local debug3 = 0

    -- Удаляем труп
    print("ISButcherZombieAction: Removing corpse")


    -- Завершаем действие
    print("ISButcherZombieAction: self = ", tostring(self))
    print("ISButcherZombieAction: self.character = ", tostring(self.character))
    print("ISButcherZombieAction: self.corpse = ", tostring(self.corpse))
    if self and self.character and instanceof(self.character, "IsoPlayer") then
        local debug4 = 0
        print("ISButcherZombieAction: Calling LuaTimedActionNew.perform")
        LuaTimedActionNew.perform(self)
        local debug5 = 0
        local square = self.corpse:getSquare()
        local debug6 = 0
        if square and instanceof(self.corpse, "IsoDeadBody") then
            local debug7 = 0
            square:removeCorpse(self.corpse, false)
            local debug8 = 0
        else
            local debug9 = 0
            print("ISButcherZombieAction: Failed to remove corpse, square or corpse invalid")
        end
        local debug10 = 0
    else
        local debug11 = 0
        print("ISButcherZombieAction: Cannot perform, self or character invalid")
        LuaTimedActionNew.stop(self)
        local debug12 = 0
    end
end

function ISButcherZombieAction:new(character, corpse)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.corpse = corpse
    o.maxTime = 600
    o.stopOnWalk = true
    o.stopOnRun = true
    o.forceProgressBar = true
    return o
end