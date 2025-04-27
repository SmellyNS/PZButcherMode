require "TimedActions/ISBaseTimedAction"

ISButcherZombieAction = ISBaseTimedAction:derive("ISButcherZombieAction")

function ISButcherZombieAction:isValid()
    if not self.corpse or not self.corpse:getSquare() then
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
    return false
end

function ISButcherZombieAction:start()
    self:setActionAnim("SliceMeat_Surface")
end

function ISButcherZombieAction:stop()
    ISBaseTimedAction.stop(self)
end

function ISButcherZombieAction:perform()
    local inventory = self.character:getInventory()
    local trappingLevel = self.character:getPerkLevel(Perks.Trapping)
    local meatCount = ZombRand(1, 3)
    local fatCount = ZombRand(1, 3)
    local boneCount = ZombRand(1, 3)

    for i = 1, math.floor(meatCount + trappingLevel * 0.5) do
        inventory:AddItem("ZombieButcher.HumanMeat")
    end
    for i = 1, math.floor(fatCount + trappingLevel * 0.5) do
        inventory:AddItem("ZombieButcher.Fat")
    end
    for i = 1, math.floor(boneCount + trappingLevel * 0.5) do
        inventory:AddItem("Base.SmallAnimalBone")
    end

    self.corpse:getSquare():removeObject(self.corpse)
    ISBaseTimedAction.perform(self)
end

function ISButcherZombieAction:new(character, corpse)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.corpse = corpse
    o.maxTime = 600 -- Соответствует time = 600 в рецепте
    return o
end