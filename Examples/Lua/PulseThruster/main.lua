local handles = {}
local elapsed = 0
local thrust = 1.5

Mod.RegisterProp({
    id = "pulse_thruster",
    base = "SmallMetalCube",
    name = "Example pulse thruster",
    description = "Applies a small pulsing upward force. Toggle with the context menu.",
    thumbnail = "Sprites/Icon.png",
    onSpawn = function(handle)
        handles[handle] = true
        World.SetMass(handle, 0.2)
        World.OnUse(handle, "Toggle thrust", function() handles[handle] = not handles[handle] end)
    end
})

Mod.OnTick(function(delta)
    elapsed = elapsed + delta
    for handle, enabled in pairs(handles) do
        if not World.Exists(handle) then
            handles[handle] = nil
        elseif enabled then
            local pulse = 0.5 + 0.5 * math.sin(elapsed * 3)
            World.ApplyForce(handle, 0, thrust * pulse)
            World.SetColor(handle, 0.2, 0.4 + pulse * 0.5, 1)
        end
    end
end)
