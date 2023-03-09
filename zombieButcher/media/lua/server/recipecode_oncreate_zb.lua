local function addFinalButcherResult(player, typeOfResult, chanse)
	local inv = player:getInventory();
	local perkLevel = player:getPerkLevel(Perks.Cooking) + player:getPerkLevel(Perks.SmallBlade);
	chanse = chanse + perkLevel * 2;
	for i = 1, 10 do
		rnd = ZombRand(1, 100)
		if rnd <= chanse then
			inv:AddItem(typeOfResult);
		end;
	end
end

function Recipe.OnCreate.Butcher(items, result, player)
	addFinalButcherResult(player, "ZombieButcher.HumanMeat", 30)
	addFinalButcherResult(player, "ZombieButcher.Fat", 35)
	addFinalButcherResult(player, "ZombieButcher.RottenBone", 35)
	
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