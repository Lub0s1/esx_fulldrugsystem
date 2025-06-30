local ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("drugsystem:collect")
AddEventHandler("drugsystem:collect", function(drug)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local item = Config.Drugs[drug] and Config.Drugs[drug].item_raw
    if not item then return end

    xPlayer.addInventoryItem(item, 1)
end)

RegisterServerEvent("drugsystem:process")
AddEventHandler("drugsystem:process", function(drug)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local data = Config.Drugs[drug]
    if not data then return end

    if xPlayer.getInventoryItem(data.item_raw).count >= 1 then
        xPlayer.removeInventoryItem(data.item_raw, 1)
        xPlayer.addInventoryItem(data.item_processed, 1)
    else
        TriggerClientEvent("ox_lib:notify", source, {
            type = "error",
            description = "Nemáš surový materiál."
        })
    end
end)

-- Predaj na fixnom mieste
RegisterServerEvent("drugsystem:sell")
AddEventHandler("drugsystem:sell", function(drug)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local data = Config.Drugs[drug]
    if not data then return end

    local item = data.item_processed
    local count = xPlayer.getInventoryItem(item).count

    if count > 0 then
        local price = math.random(data.price.min, data.price.max)
        xPlayer.removeInventoryItem(item, 1)
        xPlayer.addAccountMoney("black_money", price)

        TriggerClientEvent("ox_lib:notify", source, {
            type = "success",
            description = "Predal si drogu za $" .. price
        })

        if math.random(100) <= Config.PoliceAlertChance then
            TriggerLSPDAlert(source)
        end
    else
        TriggerClientEvent("ox_lib:notify", source, {
            type = "error",
            description = "Nemáš spracované drogy."
        })
    end
end)

-- NPC predaj
RegisterServerEvent("drugsystem:sellToNPC")
AddEventHandler("drugsystem:sellToNPC", function(drug)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local data = Config.Drugs[drug]
    if not data then return end

    local item = data.item_processed
    local count = xPlayer.getInventoryItem(item).count

    if count <= 0 then
        TriggerClientEvent("ox_lib:notify", source, {
            type = "error",
            description = "Nemáš spracované drogy."
        })
        return
    end

    local roll = math.random(1, 100)

    if roll <= 50 then
        -- 50% odmietne
        TriggerClientEvent("ox_lib:notify", source, {
            type = "error",
            description = "NPC odmietol tvoju ponuku."
        })
        return

    elseif roll <= 75 then
        -- 25% zavolá políciu
        TriggerClientEvent("ox_lib:notify", source, {
            type = "error",
            description = "NPC zavolal políciu!"
        })
        TriggerLSPDAlert(source)
        return

    else
        -- 25% kúpi (1 až 3 kusy)
        local sellCount = math.min(count, math.random(1, 3))
        local pricePerUnit = math.random(data.price.min, data.price.max) * 0.5
        local totalPrice = math.floor(pricePerUnit * sellCount)

        xPlayer.removeInventoryItem(item, sellCount)
        xPlayer.addAccountMoney("black_money", totalPrice)

        TriggerClientEvent("ox_lib:notify", source, {
            type = "success",
            description = "Predal si " .. sellCount .. "x " .. data.label .. " za $" .. totalPrice
        })
    end
end)

function TriggerLSPDAlert(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    for _, id in pairs(GetPlayers()) do
        local target = ESX.GetPlayerFromId(id)
        if target and target.job.name == "police" then
            TriggerClientEvent("ox_lib:notify", target.source, {
                type = "inform",
                description = "Hlášenie: prebieha predaj drog!"
            })
        end
    end
end

-- Only usable processed drugs:
ESX.RegisterUsableItem('weed_pooch', function(source)
    TriggerClientEvent('drugs:useWeed', source)
end)
ESX.RegisterUsableItem('coke_pooch', function(source)
    TriggerClientEvent('drugs:useCoke', source)
end)
ESX.RegisterUsableItem('meth_pooch', function(source)
    TriggerClientEvent('drugs:useMeth', source)
end)
ESX.RegisterUsableItem('opium_pooch', function(source)
    TriggerClientEvent('drugs:useOpium', source)
end)

-- Odstráni spracovanú drogu po použití:
RegisterServerEvent('drugs:removeUsedDrug')
AddEventHandler('drugs:removeUsedDrug', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeInventoryItem(item, 1)
    end
end)