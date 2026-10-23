local Thruster = Mod.RegisterPropNode {
    id = "ThrusterController", name = "Signal thruster",
    description = "Connect throttle and a direction vector. The context action toggles the motor.",
    inputs = {
        { id = "Throttle", type = "number", default = 0 },
        { id = "Direction", type = "vector", default = { x = 0, y = 1 } }
    },
    outputs = {
        { id = "Force", type = "vector" }, { id = "Speed", type = "number" }, { id = "Enabled", type = "boolean" }
    },
    state = { enabled = true },
    onInit = function(ctx) ctx.set("Enabled", ctx.state.enabled) end,
    onUse = function(ctx)
        ctx.state.enabled = not ctx.state.enabled
        ctx.set("Enabled", ctx.state.enabled)
    end,
    onTick = function(ctx, dt)
        local throttle = math.max(-1, math.min(1, ctx.inputs.Throttle))
        local direction = ctx.inputs.Direction
        local length = math.sqrt(direction.x * direction.x + direction.y * direction.y)
        local force = { x = 0, y = 0 }
        if ctx.state.enabled and length > 0.0001 then
            force.x = direction.x / length * throttle * 100
            force.y = direction.y / length * throttle * 100
            World.ApplyForce(ctx.object, force.x, force.y)
        end
        local body = World.State(ctx.object)
        ctx.set("Force", force)
        ctx.set("Speed", math.sqrt(body.vx * body.vx + body.vy * body.vy))
        World.SetColor(ctx.object, ctx.state.enabled and 0.2 or 0.5, 0.7, 0.9)
    end
}

Mod.RegisterProp {
    id = "SignalThruster", base = "SmallMetalCube", name = "Signal controlled thruster",
    description = "A Lua part with configurable logic ports. Wire it in the construction editor.",
    thumbnail = "Sprites/Icon.png", node = Thruster,
    onSpawn = function(handle) World.SetMass(handle, 1) end
}
