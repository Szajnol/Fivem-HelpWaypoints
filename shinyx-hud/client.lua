
-- // ██╗░█████╗░░█████╗░███╗░░██╗██╗░█████╗░  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
-- // ██║██╔══██╗██╔══██╗████╗░██║██║██╔══██╗  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
-- // ██║██║░░╚═╝██║░░██║██╔██╗██║██║██║░░╚═╝  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
-- // ██║██║░░██╗██║░░██║██║╚████║██║██║░░██╗  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
-- // ██║╚█████╔╝╚█████╔╝██║░╚███║██║╚█████╔╝  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
-- // ╚═╝░╚════╝░░╚════╝░╚═╝░░╚══╝╚═╝░╚════╝░  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░

local HUD_UPDATE_INTERVAL = 900
local CARHUD_SLEEP_INTERVAL = 150

local hunger, thirst, inVeh, toggle = 0, 0, false, true

local directions = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"}

local function updatePlayerStatus()
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        hunger = status.getPercent()
    end)
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        thirst = status.getPercent()
    end)
end

local function updateHud()
    SendNUIMessage({
        action = 'updateHud',
        health = LocalPlayer.state.isDead and 0 or math.floor(GetEntityHealth(cache.ped) / 2),
        hunger = hunger,
        thirst = thirst,
        talking = NetworkIsPlayerTalking(cache.playerId),
        voice = LocalPlayer.state['proximity'].distance,
    })
end

local function InitMap()
    RequestStreamedTextureDict("squaremap", false)
    while not HasStreamedTextureDictLoaded("squaremap") do
        Wait(0)
    end

    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end

    print(aspectRatio)

    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")

    SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.017, 0.1638, 0.180)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.005 + minimapOffset, 0.025, aspectRatio / 7, aspectRatio / 5.5)
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetMinimapClipType(0)

    SetRadarBigmapEnabled(true, false)
    while IsBigmapActive() do
        Wait(0)
        SetRadarBigmapEnabled(false, false)
    end
end

Citizen.CreateThread(function()
    InitMap()
    while true do
        updatePlayerStatus()
        updateHud()
        Wait(HUD_UPDATE_INTERVAL)
    end
end)

local function StartCarThread(vehicle)
    Citizen.CreateThread(function()
        while inVeh do
            local coords = GetEntityCoords(cache.ped)
            local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
            local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
            local heading = 360.0 - ((GetGameplayCamRot(0).z + 360.0) % 360.0)
    
            SendNUIMessage({
                action = "updateCarhud",
                toggle = true,
                speed = speed,
                street = street,
                fuel = Entity(vehicle).state.fuel,
                engine = GetIsVehicleEngineRunning(vehicle),
                direction = directions[(math.floor((heading / 45) + 0.5) % 8) + 1],
                belt = Config.BeltExport,
            })
            Wait(CARHUD_SLEEP_INTERVAL)
        end
    end)
end

lib.onCache('vehicle', function(value)
    inVeh = value and true or false
    DisplayRadar(inVeh)
    SendNUIMessage({action = "toggleCarhud", toggle = inVeh})
    if inVeh then
        StartCarThread(value)
    end
end)

RegisterCommand("minimapfix", function()
    RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)

RegisterCommand('hud', function()
    toggle = not toggle
    SendNUIMessage({ action = 'toggleHud', toggle = toggle })
end)

RegisterKeyMapping('hud', 'Pokaż Hud', 'MOUSE_BUTTON', 'MOUSE_MIDDLE')

exports('sendNotify', function(data) SendNUIMessage({action = 'Notify', desc = data}) end)


RegisterCommand('testNotify2', function()
    exports['shinyx-hud']:sendNotify('Otworzyłeś panel Administracyjny')
end)
