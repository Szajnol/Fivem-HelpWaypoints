Citizen.CreateThread(function()
    RequestStreamedTextureDict('texture', 'e-key', 0, 0, 0.021, 0.021, 0, 255, 255,255, 100, true)
end)


exports('DrawDestination', function (coords, label, meters)
    DrawDestination(coords, label, meters)
end)

function DrawDestination(coords, label, meters)
    local X, Y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    local icon_size = 1.5
    local text_size = 0.25
    RequestStreamedTextureDict("basejumping", false)
    DrawSprite("texture", "e-key", X, Y - 0.015, 0.018 * icon_size, 0.025 * icon_size, 0.0, 255, 255, 255, 255)
    SetTextCentre(true)
    SetTextScale(0.0, text_size)
    SetTextEntry("STRING")
    AddTextComponentString(label .. " | ".. meters .. "m")
    DrawText(X, Y + 0.015)
end
