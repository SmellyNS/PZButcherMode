local function addFinalButcherResult(player, itemType, baseChance, minCount, maxCount)
	local inv = player:getInventory()
	local trappingLevel = player:getPerkLevel(Perks.Trapping)

	-- Увеличиваем количество или шанс в зависимости от перка Trapping
	if minCount and maxCount then
		-- Для мяса, жира и маленьких костей: случайное количество
		local extraCount = math.floor(trappingLevel / (itemType == "ZombieButcher.HumanMeat" and 2 or 3))
		local count = ZombRand(minCount, maxCount + extraCount + 1)
		for i = 1, count do
			inv:AddItem(itemType)
		end
	else
		-- Для больших костей, челюсти и черепа: шанс появления
		local chance = baseChance + (itemType == "Base.LargeAnimalBone" and trappingLevel * 5 or
				itemType == "Base.JawboneBovide" and trappingLevel * 3)
		if ZombRand(1, 100) <= chance then
			inv:AddItem(itemType)
		end
	end
end

function Recipe.OnCreate.Butcher(items, result, player)
	-- Добавляем мясо (1–2 базово, до 1–7 на уровне 10)
	addFinalButcherResult(player, "ZombieButcher.HumanMeat", 0, 1, 2)

	-- Добавляем жир (1–3 базово, до 1–6 на уровне 10)
	addFinalButcherResult(player, "ZombieButcher.Fat", 0, 1, 3)

	-- Добавляем маленькие кости (1–3 базово, до 1–6 на уровне 10)
	addFinalButcherResult(player, "Base.AnimalBone", 0, 1, 3)

	-- Добавляем большие кости (шанс 10% + 5% за уровень)
	addFinalButcherResult(player, "Base.LargeAnimalBone", 10, 0, 2)

	-- Добавляем челюсть (шанс 5% + 3% за уровень)
	addFinalButcherResult(player, "Base.JawboneBovide", 5)

	-- Увеличиваем стресс и усталость
	player:getStats():setStress(player:getStats():getStress() + 0.2 + 0.02*player:getPerkLevel(Perks.Trapping))
	player:getStats():setEndurance(player:getStats():getEndurance() - 0.2 + 0.01*player:getPerkLevel(Perks.Trapping))

	-- Шанс тошноты (50% на уровне 0, уменьшается до 0% на уровне 10)
	local nauseaChance = 50 - player:getPerkLevel(Perks.Trapping) * 5
	if ZombRand(1, 100) <= nauseaChance then
		player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + 20)
		player:Say("Ugh, this is disgusting...")
	end
end

function Recipe.OnCreate.CrushBones(items, result, player)
	local inv = player:getInventory()
	inv:AddItem("ZombieButcher.BoneFlour")
end

function Recipe.OnCreate.MixBoneFlour(items, result, player)
	local inv = player:getInventory()
	inv:AddItem("ZombieButcher.MixedBoneFlour")
	inv:AddItem("Base.Pot") -- Возвращаем пустую кастрюлю
end

function Recipe.OnCreate.ExtractGlue(items, result, player)
	local inv = player:getInventory()
	for i = 1, 2 do
		inv:AddItem("Base.Glue")
	end
	inv:AddItem("Base.Pot") -- Возвращаем пустую кастрюлю
end

function Recipe.OnCreate.CreateBilletSoap(items, result, player)
	local inv = player:getInventory()
	inv:AddItem("ZombieButcher.BilletSoap")
	inv:AddItem("Base.Pot") -- Возвращаем пустую кастрюлю
end

function Recipe.OnCreate.ExtractSoapFromThePot(items, result, player)
	local inv = player:getInventory()
	for i = 1, 2 do
		inv:AddItem("Base.Soap2")
	end
	inv:AddItem("Base.Pot") -- Возвращаем пустую кастрюлю
end

function Recipe.OnCreate.PreparedFat(items, result, player)
	local inv = player:getInventory()
	inv:AddItem("ZombieButcher.PreparedFat")
	inv:AddItem("Base.Saucepan") -- Возвращаем пустую сковороду
end