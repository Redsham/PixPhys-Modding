local Thermostat = Mod.RegisterComponent {
    id = "Thermostat", name = "Increase target temperature",
    state = { target = 30 },
    onUse = function(ctx)
        ctx.state.target = ctx.state.target >= 100 and 30 or ctx.state.target + 10
    end,
    onTick = function(ctx, dt)
        World.SetTemperature(ctx.object, ctx.state.target)
    end
}

local Impacts = Mod.RegisterComponent {
    id = "ImpactCounter", name = "Reset impact counter",
    state = { impacts = 0, strongest = 0 },
    onCollision = function(ctx, collision)
        ctx.state.impacts = ctx.state.impacts + 1
        ctx.state.strongest = math.max(ctx.state.strongest, collision.speed)
        World.SetColor(ctx.object, math.min(1, 0.2 + ctx.state.impacts * 0.1), 0.5, 0.8)
    end,
    onUse = function(ctx)
        ctx.state.impacts = 0
        ctx.state.strongest = 0
        World.SetColor(ctx.object, 0.2, 0.5, 0.8)
    end
}

Mod.RegisterProp {
    id = "StatefulBlock", base = "SmallMetalCube", name = "Block with saved Lua components",
    description = "Two independent saved components: a thermostat and an impact counter.",
    thumbnail = "Sprites/Icon.png", components = { Thermostat, Impacts }
}
