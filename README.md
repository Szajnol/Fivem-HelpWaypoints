# Fivem-HelpWaypoints
Simple fivem script for creating helpful markers on the map in the game making gameplay easier and looking nice

![image](https://github.com/user-attachments/assets/bb867ce7-27fa-4fb7-815c-a6a8a663edc7)

## Usage/Examples

### In loop
```lua
local coords = vec3(2281.5424804688, 4813.0190429688, 55.574935913086 - 1.0)

while true do 
    local playercoords = GetEntityCoords(PlayerPedId())
    local dist = #(coords-playercoords)
    local metry = math.ceil(dist * 1)
    exports['shinyx-HelpWaypoints']:DrawDestination(coords, "Example", metry)
    Wait(0)
end
```

## FAQ

#### Can I use it in job, for example?

Of course you can, most things are possible in this script

#### Will the script ever be updated?

Not likely, and if we do, we'll be sure to let you know on our discord : https://discord.gg/iconicscripts
