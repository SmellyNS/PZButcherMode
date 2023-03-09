local function addFinalResult(player, typeOfResult)
	local inv = player:getInventory();
	local perkLevel = player:getPerkLevel(Perks.Cooking);
	for i = 0, perkLevel do
		inv:AddItem(typeOfResult);
	end
end

function Recipe.OnCreate.Butcher(items, result, player)
	addFinalResult(player, "ZombieButcher.HumanMeat")
	addFinalResult(player, "ZombieButcher.Fat")
	addFinalResult(player, "ZombieButcher.RottenBone")
	
	player:getStats():setEndurance(player:getStats():getEndurance() - 0.2)
	player:getStats():setStress(player:getStats():getStress() + 0.2)
end

function Recipe.OnCreate.MixBoneFlour(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("ZombieButcher.MixedBoneFlour");
end

function Recipe.OnCreate.ExtractGlue(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("Pot");
end

function Recipe.OnCreate.CreateBilletSoap(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("ZombieButcher.BilletSoap");
end

function Recipe.OnCreate.ExtractSoapFromThePot(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("Pot");
end

function Recipe.OnCreate.PreparedFat(items, result, player)
    local inv = player:getInventory();
	inv:AddItem("ZombieButcher.PreparedFat");
end

function Recipe.OnCreate.BilletCandles(items, result, player)
    local inv = player:getInventory();
	inv:AddItem("ZombieButcher.BilletCandles");
end

function Recipe.OnCreate.ExtractCandlesFromTheTray(items, result, player)
    local inv = player:getInventory();
	inv:AddItem("MuffinTray");
end