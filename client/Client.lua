local PlayerPedId, NetworkIsPlayerTalking, GetPlayerSprintStaminaRemaining, SendNUIMessage = PlayerPedId, NetworkIsPlayerTalking, GetPlayerSprintStaminaRemaining, SendNUIMessage
local money, bank = 0, 0
local loaded = false

function GetPlayerMugshot(ped, transparent)
    if not DoesEntityExist(ped) then return end
    local mugshot = transparent and RegisterPedheadshotTransparent(ped) or RegisterPedheadshot(ped)

    while not IsPedheadshotReady(mugshot) do
        Wait(5000)
    end

    return mugshot, GetPedheadshotTxdString(mugshot)
end

local mostrar = true 

RegisterCommand(Config.CommandHideHud, function ()
    if mostrar then 
         mostrar = false
    else 
        mostrar = true
    end
end)


AddEventHandler('playerSpawned', function() 
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
 
    PlayerData = ESX.GetPlayerData()
    for i = 1, #PlayerData.accounts do
        if PlayerData.accounts[i].name == 'money' then
            money = PlayerData.accounts[i].money
        elseif PlayerData.accounts[i].name == 'bank' then
            bank = PlayerData.accounts[i].money
        end
    end

    SendNUIMessage({
        action = 'UpdateMoney';
        money = money;
        bank = bank;
    })


    SendNUIMessage({
        action = 'UpdateJob', 
        job = PlayerData.job.label
    })
    
end)



RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    if account.name == 'money' then
        money = account.money
    elseif account.name == 'bank' then
        bank = account.money
    end
    SendNUIMessage({
        action = 'UpdateMoney';
        money = money;
        bank = bank;
    })
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    SendNUIMessage({
        action = 'UpdateJob', 
        job = job.label
    })

end)


CreateThread(function() 
        while true do 
            Wait(1000)
            if not IsPauseMenuActive() and loaded and mostrar then 
                local player = PlayerPedId()
                local playerid = PlayerId()

                SendNUIMessage({
                    action = 'update',
                    food = food, 
                    water = water,
                    nombre = GetPlayerName(playerid),
                    pid = GetPlayerServerId(playerid),
                    talking = NetworkIsPlayerTalking(playerid),
                })
            else
                SendNUIMessage({
                    action = 'hideAllHud'
                })
            end
        end
end)

CreateThread(function() 
    while true do 
        Wait(Config.timetomugshot)
        if not IsPauseMenuActive() and loaded and mostrar then 
            local playerPed = PlayerPedId()
            local mugshot, mugshotStr = GetPlayerMugshot(playerPed, true)

            SendNUIMessage({
                action = 'mugshotes',
                img = mugshotStr,
            })
        else
            SendNUIMessage({
                action = 'hideAllHud'
            })
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            while ESX.GetPlayerData().job == nil do
                Wait(10)
            end
         
            PlayerData = ESX.GetPlayerData()
            loaded = true
            for i = 1, #PlayerData.accounts do
                if PlayerData.accounts[i].name == 'money' then
                    money = PlayerData.accounts[i].money
                elseif PlayerData.accounts[i].name == 'bank' then
                    bank = PlayerData.accounts[i].money
                end
            end
            SendNUIMessage({
                action = 'UpdateMoney';
                money = money;
                bank = bank;
            })

            SendNUIMessage({
                action = 'UpdateJob', 
                job = PlayerData.job.label
            })

            break
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    SendNUIMessage({
        action = 'UpdateJob', 
        job = xPlayer.job.label,
        datajob = xPlayer.job.name
    })
end)

AddEventHandler('pma-voice:setTalkingMode', function()
    SendNUIMessage({ 
        action = 'UpdateVoice', 
        value = LocalPlayer.state.proximity and LocalPlayer.state.proximity.mode or "Normal" })
end)



food, water = 0, 0
CreateThread(function()
    while true do
        Wait(Config.StatusUpdateInterval)
        if not IsPauseMenuActive() and loaded and mostrar then 
            GetStatus(function(data)
                food = data[1]
                water = data[2]
            end)
        end
    end
end)
