local function addFinalResult(player, typeOfResult)
	local inv = player:getInventory();
	local perkLevel = player:getPerkLevel(Perks.Cooking);
	for i = 0, perkLevel do
		inv:AddItem(typeOfResult);
	end
	
	
	--local arr = {}
	--for i = 1, 10 do
	--	print("randomed int: ")
	--	arr[i] = math.random(10)
	--	print(arr[i])
	--end
	--table.sort(arr)
	--print("cooking level: ")
	--print(player:getPerkLevel(Perks.Cooking))
	--print("arr: ")
	--print(arr)
	--local actualResult = arr[player:getPerkLevel(Perks.Cooking)]
	--for i = 0, actualResult-1 do
	--	inv:AddItem(typeOfResult);
	--end
end

function onCreateButcher(items, result, player)
	addFinalResult(player, "ZombieMeat.HumanMeat")
	addFinalResult(player, "ZombieMeat.ZMFat")
	addFinalResult(player, "ZombieMeat.RottenBone")
	
	player:getStats():setEndurance(player:getStats():getEndurance() - 0.2)
	player:getStats():setStress(player:getStats():getStress() + 0.2)
end


function canPerformButcher(recipe, player)
	return player:getStats():getEndurance() > 0.1 and player:getStats():getStress() < 1
end