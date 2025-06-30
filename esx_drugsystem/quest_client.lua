local hasQuest = false
local collected = 0
local questDealer = vector3(-437.5, 6020.3, 31.5)

function StartWeedQuest()
    hasQuest = true
    collected = 0
    ESX.ShowNotification("Zber 5x weed_leaf a odnes to dealerovi v Paleto Bay.")
    SetNewWaypoint(2220.0, 5577.0) -- waypoint na zber weed
end

RegisterCommand("startquest", function()
    if not hasQuest then
        StartWeedQuest()
    else
        ESX.ShowNotification("Už máš aktívnu úlohu.")
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        if hasQuest then
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)

            -- kontrola zberu
            if #(coords - vector3(2220.0, 5577.0, 53.8)) < 2.0 and collected < 5 then
                ESX.ShowHelpNotification("Stlač ~INPUT_CONTEXT~ pre zber weed")
                if IsControlJustReleased(0, 38) then
                    collected += 1
                    ESX.ShowNotification("Pozbierané: " .. collected .. "/5")
                    if collected >= 5 then
                        ESX.ShowNotification("Odnes weed dealerovi v Paleto Bay.")
                        SetNewWaypoint(questDealer.x, questDealer.y)
                    end
                end
            end

            -- odovzdanie dealerovi
            if collected >= 5 and #(coords - questDealer) < 2.0 then
                ESX.ShowHelpNotification("Stlač ~INPUT_CONTEXT~ pre odovzdanie")
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("quest:reward")
                    hasQuest = false
                    collected = 0
                end
            end
        end
    end
end)
