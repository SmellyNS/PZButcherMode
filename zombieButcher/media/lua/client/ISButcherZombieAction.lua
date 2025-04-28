require "TimedActions/ISBaseTimedAction"

ISButcherZombieAction = ISBaseTimedAction:derive("ISButcherZombieAction")

function ISButcherZombieAction:addFinalButcherResult(player, itemType, baseChance, minCount, maxCount)
    local inv = self.character:getInventory()
    local ButcheringLevel = self.character:getPerkLevel(Perks.Butchering)

    -- Увеличиваем количество или шанс в зависимости от перка Butchering
    if minCount and maxCount then
        -- Для мяса, жира и маленьких костей: случайное количество
        local extraCount = math.floor(ButcheringLevel / (itemType == "ZombieButcher.HumanMeat" and 2 or 3))
        local count = ZombRand(minCount, maxCount + extraCount + 1)
        for i = 1, count do
            local item = inv:AddItem(itemType)
            if item and itemType == "ZombieButcher.HumanMeat" then
                item:setAge(5)
            end
        end
    else
        -- Для больших костей, челюсти и черепа: шанс появления
        local chance = baseChance + (itemType == "Base.LargeAnimalBone" and ButcheringLevel * 5 or
                itemType == "Base.JawboneBovide" and ButcheringLevel * 3)
        if ZombRand(1, 100) <= chance then
            inv:AddItem(itemType)
        end
    end
end

function ISButcherZombieAction:isValid()
    if not self.corpse or not self.corpse:getSquare() or not instanceof(self.corpse, "IsoDeadBody") then
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
    self.character:faceThisObject(self.corpse)
end

function ISButcherZombieAction:stop()
    ISBaseTimedAction.stop(self)
end

function ISButcherZombieAction:perform()

    if (not self.corpse:isSkeleton()) then
        -- Добавляем мясо (1–2 базово, до 1–7 на уровне 10)
        self:addFinalButcherResult(player, "ZombieButcher.HumanMeat", 0, 1, 2)

        -- Добавляем жир (1–3 базово, до 1–6 на уровне 10)
        self:addFinalButcherResult(player, "ZombieButcher.Fat", 0, 1, 3)

    end

    -- Добавляем маленькие кости (1–3 базово, до 1–6 на уровне 10)
    self:addFinalButcherResult(player, "Base.AnimalBone", 0, 1, 3)

    -- Добавляем большие кости (шанс 10% + 5% за уровень)
    self:addFinalButcherResult(player, "Base.LargeAnimalBone", 10, 0, 2)

    -- Добавляем челюсть (шанс 5% + 3% за уровень)
    self:addFinalButcherResult(player, "Base.JawboneBovide", 5)

    -- Увеличиваем стресс и усталость
    self.character:getStats():setStress(self.character:getStats():getStress() + 0.2 + 0.02*self.character:getPerkLevel(Perks.Butchering))
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.2 + 0.01*self.character:getPerkLevel(Perks.Butchering))

    -- Шанс тошноты (50% на уровне 0, уменьшается до 0% на уровне 10)
    local nauseaChance = 50 - self.character:getPerkLevel(Perks.Butchering) * 5
    if ZombRand(1, 100) <= nauseaChance then
        self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() + 20)
        local phrases = {
            "Ugh, done. I’m gonna puke.",
            "Sliced up. This is messing me up.",
            "Chopped. God, I hate this job.",
            "Finished. My stomach’s turning.",
            "Carved, but… ugh, that smell.",
            "All done. I need a shower.",
            "Cut up. Why’s it always me?",
            "Processed. I’m feeling sick.",
            "Sawed through. This is grim.",
            "Another one down. I’m not okay.",
            "Diced. My hands are shaking.",
            "Hacked up. I can’t stand this.",
            "Bones and meat. I’m gonna hurl.",
            "Sliced. This is a nightmare.",
            "Work’s over. I feel filthy.",
            "Torn apart. My mood’s in the dirt.",
            "Butchered. I’m done with this crap.",
            "All in pieces. I’m so grossed out.",
            "Minced. I’m not built for this.",
            "Job’s done. I need a drink.",
            "Ugh, it’s done. I feel like throwing up.",
            "Sliced. This is ruining my day.",
            "Chopped up. My stomach’s in knots.",
            "Finished. I’m never getting used to this.",
            "Carved. God, that was awful.",
            "All cut. I need to lie down.",
            "Hacked apart. I’m feeling queasy.",
            "Done. This is way too much for me.",
            "Sawed up. I’m gonna be sick.",
            "Another one diced. I’m a wreck.",
            "Processed. My hands won’t stop shaking.",
            "Torn to bits. This is disgusting.",
            "Bones and meat. I’m done with this.",
            "Sliced through. I hate every second.",
            "Work’s over. I feel like garbage.",
            "Butchered. My mood’s shot to hell.",
            "All in chunks. I’m grossed out.",
            "Minced up. Why am I doing this?",
            "Cut and bagged. I’m falling apart.",
            "Job’s done. I can’t take this anymore.",
        }
        local phrase_nb = ZombRand(1, #phrases-1)
        local phrase = phrases[phrase_nb]

        self.character:Say(phrase)
    else
        local phrases = {
            "Another corpse turned into fertilizer.",
            "This one’s ready to rot the fields.",
            "Meat for the dirt, bones for the pile.",
            "One less zombie, one more sack of goods.",
            "Sliced and diced. Next customer!",
            "Clean cuts, no fuss. I’m getting good at this.",
            "Plenty of fat for the candles.",
            "Chop, slice, done. Who's hungry?",
            "Another day, another pile of bait.",
            "Waste-free production. Nice!",
            "Done. Another one carved up.",
            "Sliced and sorted. Next.",
            "All chopped, job’s over.",
            "Clean cut, that’s a wrap.",
            "Finished. Bones and meat bagged.",
            "Another corpse processed.",
            "Cut up neat, moving on.",
            "Work’s done, all in pieces.",
            "Sawed through, that’s it.",
            "Another one down, sliced.",
            "Chopped up, good enough.",
            "All diced, calling it a day.",
            "Carved and packed, finished.",
            "Bones and meat, job complete.",
            "Quick slice, all done.",
            "Another body taken apart.",
            "Cut and sorted, that’s that.",
            "Processed, ready for the next.",
            "Sliced up, nothing left.",
            "Job’s over, all in bits.",
            "Sawed through. He’s less of a problem now.",
            "Work’s done. This guy’s literally spineless.",
            "He'll be more useful in chunks."
        }
        local phrase_nb = ZombRand(1, #phrases-1)
        local phrase = phrases[phrase_nb]

        self.character:Say(phrase)
    end

    local square = self.corpse:getSquare()
    if square and instanceof(self.corpse, "IsoDeadBody") then
        square:removeCorpse(self.corpse, false)
    end

    ISBaseTimedAction.perform(self)
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