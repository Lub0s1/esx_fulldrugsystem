local ESX = exports['es_extended']:getSharedObject()
local lib = exports.ox_lib
local soldTo = {}
local cooldown = false

local function notify(msg, type)
    lib.notify({
        title = "Drogy",
        description = msg,
        type = type or "inform"
    })
end

local function playAnimation()
    local ped = PlayerPedId()
    local dict = "anim@amb@business@coc@coc_unpack_cut_left@"
    local anim = "coke_cut_v5_coccutter"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, 4000, 1, 0, false, false, false)
    FreezeEntityPosition(ped, true)
    Wait(4000)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
end

local function getAvailableDrug()
    for name, drug in pairs(Config.Drugs) do
        local count = exports.ox_inventory:GetItemCount(drug.item_processed)
        if count and count > 0 then return name, drug end
    end
    return nil, nil
end

-- ox_target pre náhodných civilistov (NPC)
exports.ox_target:addGlobalPed({
    {
        name = 'sell_to_npc',
        icon = 'hand-holding-dollar',
        label = 'Predať drogy',
        distance = 2.0,
        canInteract = function(entity)
            return not IsPedAPlayer(entity)
                and not IsPedDeadOrDying(entity, true)
                and not IsPedInAnyVehicle(entity, true)
                and not soldTo[entity]
                and getAvailableDrug()
        end,
        onSelect = function(data)
            local ped = data.entity
            local drugName, drug = getAvailableDrug()
            if not drugName then
                notify("Nemáš žiadne drogy.", "error")
                return
            end
            soldTo[ped] = true
            playAnimation()
            TriggerServerEvent("drugsystem:sellToNPC", drugName)
        end
    }
})

-- ox_target zóny pre statický predaj
CreateThread(function()
    for name, drug in pairs(Config.Drugs) do
        if drug.sell then
            exports.ox_target:addBoxZone({
                coords = drug.sell,
                size = vec3(2, 2, 2),
                rotation = 45,
                debug = false,
                options = {
                    {
                        name = 'sell_' .. name,
                        icon = 'fas fa-cannabis',
                        label = 'Predať ' .. drug.label,
                        distance = 2.0,
                        onSelect = (function(drugName)
                            return function()
                                local drugData = Config.Drugs[drugName]
                                local count = exports.ox_inventory:GetItemCount(drugData.item_processed)
                                if count and count > 0 then
                                    playAnimation()
                                    TriggerServerEvent('drugsystem:sell', drugName)
                                else
                                    notify("Nemáš spracované drogy.", "error")
                                end
                            end
                        end)(name)
                    }
                }
            })
        end
    end
end)

-- Drug effects:




-- Aktualizované efekty s notifikáciami a odstránením:




-- Efekty na 60 sekúnd bez odobratia itemu a bez notifikácií:




-- Efekty s animáciou, 60 sekúnd, odoberie item:



RegisterNetEvent('drugs:useOpium', function()
    local ped = PlayerPedId()
    RequestAnimDict("amb@world_human_leaning@female@wall@back@hand_up@idle_a")
    while not HasAnimDictLoaded("amb@world_human_leaning@female@wall@back@hand_up@idle_a") do Wait(10) end
    TaskPlayAnim(ped, "amb@world_human_leaning@female@wall@back@hand_up@idle_a", "idle_a", 8.0, -8.0, 2500, 1, 0, false, false, false)
        Wait(2500)
    
TriggerServerEvent('drugs:removeUsedDrug', 'opium_pooch')

    StartScreenEffect("DeathFailOut", 0, true)
    SetTimecycleModifier("NG_blackout")
    Wait(60000)
    StopScreenEffect("DeathFailOut")
    ClearTimecycleModifier()
end)

-- Final working drug effects:
RegisterNetEvent('drugs:useWeed', function()
    local ped = PlayerPedId()
    RequestAnimDict("amb@world_human_drug_dealer_hard@idle_a")
    while not HasAnimDictLoaded("amb@world_human_drug_dealer_hard@idle_a") do Wait(10) end
    TaskPlayAnim(ped, "amb@world_human_drug_dealer_hard@idle_a", "idle_a", 8.0, -8.0, 2500, 1, 0, false, false, false)

    Wait(2500)
    
TriggerServerEvent('drugs:removeUsedDrug', 'weed_pooch')

    StartScreenEffect("DrugsMichaelAliensFight", 0, true)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(ped, true)
    local timer = GetGameTimer() + 60000
    while GetGameTimer() < timer do
        Wait(1000)
    end
    StopScreenEffect("DrugsMichaelAliensFight")
    ClearTimecycleModifier()
    SetPedMotionBlur(ped, false)
end)

RegisterNetEvent('drugs:useCoke', function()
    local ped = PlayerPedId()
    RequestAnimDict("mp_suicide")
    while not HasAnimDictLoaded("mp_suicide") do Wait(10) end
    TaskPlayAnim(ped, "mp_suicide", "pill", 8.0, -8.0, 2500, 1, 0, false, false, false)

    Wait(2500)
    
TriggerServerEvent('drugs:removeUsedDrug', 'coke_pooch')

    SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
    local timer = GetGameTimer() + 60000
    while GetGameTimer() < timer do
        Wait(1000)
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end)

RegisterNetEvent('drugs:useMeth', function()
    local ped = PlayerPedId()
    RequestAnimDict("rcmextreme3")
    while not HasAnimDictLoaded("rcmextreme3") do Wait(10) end
    TaskPlayAnim(ped, "rcmextreme3", "idle", 8.0, -8.0, 2500, 1, 0, false, false, false)

    Wait(2500)
    
TriggerServerEvent('drugs:removeUsedDrug', 'meth_pooch')

    StartScreenEffect("DrugsMichaelAliensFight", 0, true)
    SetPedMovementClipset(ped, "move_m@drunk@verydrunk", 1.0)
    local timer = GetGameTimer() + 60000
    while GetGameTimer() < timer do
        Wait(1000)
    end
    StopScreenEffect("DrugsMichaelAliensFight")
    ResetPedMovementClipset(ped, 0.0)
end)

RegisterNetEvent('drugs:useOpium', function()
    local ped = PlayerPedId()
    RequestAnimDict("amb@world_human_leaning@female@wall@back@hand_up@idle_a")
    while not HasAnimDictLoaded("amb@world_human_leaning@female@wall@back@hand_up@idle_a") do Wait(10) end
    TaskPlayAnim(ped, "amb@world_human_leaning@female@wall@back@hand_up@idle_a", "idle_a", 8.0, -8.0, 2500, 1, 0, false, false, false)

    Wait(2500)
    
TriggerServerEvent('drugs:removeUsedDrug', 'opium_pooch')

    StartScreenEffect("DeathFailOut", 0, true)
    SetTimecycleModifier("NG_blackout")
    local timer = GetGameTimer() + 60000
    while GetGameTimer() < timer do
        Wait(1000)
    end
    StopScreenEffect("DeathFailOut")
    ClearTimecycleModifier()
end)

-- Zber a spracovanie zón:
-- Zber a spracovanie drog (ox_target zóny)
CreateThread(function()
    for name, drug in pairs(Config.Drugs) do
        -- ZBER
        if drug.collect then
            exports.ox_target:addBoxZone({
                coords = drug.collect,
                size = vec3(2, 2, 2),
                rotation = 0,
                debug = false,
                options = {
                    {
                        name = 'collect_' .. name,
                        icon = 'fas fa-seedling',
                        label = 'Zbierať ' .. drug.label,
                        onSelect = function()
                            playAnimation()
                            TriggerServerEvent("drugsystem:collect", name)
                        end
                    }
                }
            })
        end

        -- SPRACOVANIE
        if drug.process then
            exports.ox_target:addBoxZone({
                coords = drug.process,
                size = vec3(2, 2, 2),
                rotation = 0,
                debug = false,
                options = {
                    {
                        name = 'process_' .. name,
                        icon = 'fas fa-flask',
                        label = 'Spracovať ' .. drug.label,
                        onSelect = function()
                            playAnimation()
                            TriggerServerEvent("drugsystem:process", name)
                        end
                    }
                }
            })
        end
    end
end)