RegisterServerEvent("quest:reward")
AddEventHandler("quest:reward", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem("weed_leaf").count >= 5 then
        xPlayer.removeInventoryItem("weed_leaf", 5)
        xPlayer.addAccountMoney("black_money", 500)
        TriggerClientEvent("esx:showNotification", source, "Dostal si 500$ za úlohu.")
    else
        TriggerClientEvent("esx:showNotification", source, "Nemáš 5x weed_leaf.")
    end
end)
