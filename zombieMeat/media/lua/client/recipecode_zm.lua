local function addFinalResult(player, typeOfResult)
	local inv = player:getInventory();
	arr = {}
	for i = 0, 9 do
		arr[i] = math.random(10)
	end
	table.sort(arr)
	local actualResult = arr[player:getPerkLevel(Perks.Cooking)]
	for i = 0, actualResult do
		inv:AddItem(typeOfResult);
	end
end

function Butcher(items, result, player)
	local inv = player:getInventory();
	
	addFinalResult(player, "ZombieMeat.HumanMeat")
	addFinalResult(player, "ZombieMeat.ZMFat")
	addFinalResult(player, "ZombieMeat.RottenBone")
	
end





player:getPerkLevel(Perks.MetalWelding)