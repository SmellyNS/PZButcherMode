function CreateBilletSoap(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("ZombieMeat.ZMBilletSoap");
end

function ExtractSoapFromThePot(items, result, player)
	local inv = player:getInventory();
	inv:AddItem("Pot");
end

function CreatePreparedFat(items, result, player)
    local inv = player:getInventory();
	inv:AddItem("ZombieMeat.ZMPreparedFat");
end

function CreateBilletCandles(items, result, player)
    local inv = player:getInventory();
	inv:AddItem("ZombieMeat.ZMBilletCandles");
end

function ExtractCandlesFromTheTray(items, result, player)
    local inv = player:getInventory();
	inv:AddItem("MuffinTray");
end