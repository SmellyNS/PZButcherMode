function onCreateMixBoneFlour(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("ZombieMeat.MixedBoneFlour");
end
function onCreateExtractGlue(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("Pot");
end