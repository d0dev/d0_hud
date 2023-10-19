RegisterServerEvent('renzu_hygiene:syncshower')
AddEventHandler('renzu_hygiene:syncshower', function(zone)
    local Source = source
    TriggerClientEvent('renzu_hygiene:syncshower', -1, zone, GetEntityCoords(GetPlayerPed(Source)), Source)
end)


RegisterServerEvent('renzu_hygiene:odoreffectsync')
AddEventHandler('renzu_hygiene:odoreffectsync', function()
    local Source = source
    TriggerClientEvent('renzu_hygiene:odoreffect', -1, GetEntityCoords(GetPlayerPed(Source)), Source)
end)