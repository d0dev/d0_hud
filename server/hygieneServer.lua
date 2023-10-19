RegisterServerEvent('renzu_hygiene:syncshower')
AddEventHandler('renzu_hygiene:syncshower', function(zone)
    local Source = source
    TriggerClientEvent('renzu_hygiene:syncshower', -1, zone, GetEntityCoords(GetPlayerPed(Source)), Source)
end)
