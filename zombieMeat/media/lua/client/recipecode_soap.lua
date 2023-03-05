function CreateBilletSoap(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("ZombieMeat.ZMBilletSoap");
end
function ExtractSoapFromThePot(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("Pot");
end