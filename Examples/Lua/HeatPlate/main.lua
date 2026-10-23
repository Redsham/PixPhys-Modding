local settings = require("settings")
local target = tonumber(Storage.Get("target")) or settings.cool

Mod.RegisterProp({
    id = "heat_plate",
    base = "SmallMetalCube",
    name = "Example heat plate",
    description = "Choose Toggle heat in the context menu.",
    thumbnail = "Sprites/Icon.png",
    onSpawn = function(handle)
        World.SetColor(handle, 1, 0.4, 0.15)
        World.SetTemperature(handle, target)
        World.OnUse(handle, "Toggle heat", function()
            target = target == settings.cool and settings.hot or settings.cool
            World.SetTemperature(handle, target)
            Storage.Set("target", tostring(target))
        end)
    end
})
