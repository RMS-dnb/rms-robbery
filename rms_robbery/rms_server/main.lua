local RSGCore = exports['rsg-core']:GetCoreObject()

-- Define a global cooldown time in milliseconds (e.g., 5 minutes)
local globalCooldownTime = 300000 -- 5 minutes in milliseconds

-- Create a table to store the last robbery times for each player
local lastRobberyTimes = {}

RegisterNetEvent("rms_robbery:startToRob")
AddEventHandler("rms_robbery:startToRob", function()
    local _source = source
    local Player = RSGCore.Functions.GetPlayer(_source)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    
    
    -- Check if the player is on cooldown
    local currentTime = GetGameTimer()
    local lastRobberyTime = lastRobberyTimes[_source] or 0
    
    if currentTime - lastRobberyTime < globalCooldownTime then
        local remainingCooldown = math.ceil((globalCooldownTime - (currentTime - lastRobberyTime)) / 1000)
        TriggerClientEvent('RSGCore:Notify', _source, ('You are on cooldown. Wait ' .. remainingCooldown .. ' seconds before robbing again.'), 'error')
        return
    end
    
    local count = Player.Functions.GetItemByName("lockpick").amount
    if count >= 1 then
        Player.Functions.RemoveItem("lockpick", 1)
        TriggerClientEvent('rms_robbery:startTimer', _source)
        TriggerClientEvent('rms_robbery:startAnimation', _source)
        -- webhook
        TriggerEvent('rsg-log:server:CreateLog', 'robbing', 'Robbing Shop', 'yellow', firstname..' '..lastname..' Robbed Van Horn shop')
        Citizen.Wait(32000)
        Player.Functions.AddMoney('cash', 150)
        
        -- Update the last robbery time for this player
        lastRobberyTimes[_source] = GetGameTimer()
    else
        TriggerClientEvent('RSGCore:Notify', _source, ('You need a lockpick mate'), 'error')
    end     
end)

RegisterNetEvent("rms_robbery:payout")
AddEventHandler("rms_robbery:payout", function()
    local _source = source
    local Player = RSGCore.Functions.GetPlayer(_source)
    
    if not IsPlayerDead(_source) then
        TriggerClientEvent('RSGCore:Notify', _source, 'You successfully stole $150', 'success')
    else
        TriggerClientEvent('RSGCore:Notify', _source, 'You are dead fool ', 'error')
    end
end)
