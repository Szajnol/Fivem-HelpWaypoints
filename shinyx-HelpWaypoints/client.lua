CreateThread(function()
    RequestStreamedTextureDict('texture', true) 
    while not HasStreamedTextureDictLoaded('texture') do
        Wait(0)
    end
end)

exports('DrawDestination', function(coords, label, meters)
    DrawDestination(coords, label, meters)
end)

function DrawDestination(coords, label, meters)
    coords = vector3(coords.x, coords.y, coords.z + 1)
    local success, X, Y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if success then
        local icon_size = 1.5
        local text_size = 0.25

        if HasStreamedTextureDictLoaded('texture') then
            DrawSprite("texture", "e-key", X, Y - 0.015, 0.018 * icon_size, 0.025 * icon_size, 0.0, 255, 255, 255, 255)
        else
            print("Error: Texture dictionary 'commonmenu' not loaded!")
        end
        SetTextCentre(true)
        SetTextScale(0.0, text_size)
        SetTextEntry("STRING")
        AddTextComponentString(label .. " | " .. meters .. "m")
        DrawText(X, Y + 0.015)
    else
        print("Warning: Coordinates cannot be converted to screen position.")
    end
end

-- Example waypoint thread
CreateThread(function()
    local coords = vec3(725.287415, -1422.674316, 31.422318 -1)

    while true do 
        local playercoords = GetEntityCoords(PlayerPedId())
        local dist = #(coords - playercoords)
        local meters = math.ceil(dist)

        exports['shinyx-HelpWaypoints']:DrawDestination(coords, "Example", meters)
        Wait(0)
    end
end)
