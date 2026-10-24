local Telemetry = Mod.RegisterDataType {
    id = "Telemetry",
    fields = { speed = "number", temperature = "number", enabled = "boolean", position = "vector" },
    default = { speed = 0, temperature = 20, enabled = true, position = { x = 0, y = 0 } },
    color = { r = 0.2, g = 0.8, b = 0.6 }
}

local function pack(ctx)
    ctx.set("Telemetry", Types.New(Telemetry, {
        speed = ctx.inputs.Speed,
        temperature = ctx.inputs.Temperature,
        enabled = ctx.inputs.Enabled,
        position = ctx.inputs.Position
    }))
end

Mod.RegisterNode {
    id = "PackTelemetry", name = "Pack telemetry", category = "Composite",
    description = "Combines speed, temperature, enable state and position into a typed signal.",
    inputs = {
        { id = "Speed", type = "number", default = 5 },
        { id = "Temperature", type = "number", default = 20 },
        { id = "Enabled", type = "boolean", default = true },
        { id = "Position", type = "vector", default = { x = 0, y = 0 } }
    },
    outputs = { { id = "Telemetry", type = Telemetry } },
    onInit = pack,
    onInput = function(ctx, port, value) pack(ctx) end
}

local function unpack(ctx)
    local value = ctx.inputs.Telemetry
    assert(Types.Is(value, Telemetry))
    ctx.set("Speed", value.speed)
    ctx.set("Temperature", value.temperature)
    ctx.set("Enabled", value.enabled)
    ctx.set("Position", value.position)
end

Mod.RegisterNode {
    id = "ReadTelemetry", name = "Read telemetry", category = "Composite",
    description = "Splits the custom telemetry signal into ordinary game channels.",
    inputs = { { id = "Telemetry", type = Telemetry } },
    outputs = {
        { id = "Speed", type = "number" }, { id = "Temperature", type = "number" },
        { id = "Enabled", type = "boolean" }, { id = "Position", type = "vector" }
    },
    onInit = unpack,
    onInput = function(ctx, port, value) unpack(ctx) end
}

Mod.RegisterNode {
    id = "DistanceCounter", name = "Telemetry distance counter", category = "Math",
    description = "Integrates absolute speed over time. Its total is saved with each node instance.",
    inputs = { { id = "Telemetry", type = Telemetry }, { id = "Reset", type = "boolean", default = false } },
    outputs = { { id = "Distance", type = "number" } },
    state = { distance = 0 },
    onInit = function(ctx) ctx.set("Distance", ctx.state.distance) end,
    onInput = function(ctx, port, value)
        if port == "Reset" and value then ctx.state.distance = 0; ctx.set("Distance", 0) end
    end,
    onTick = function(ctx, dt)
        if ctx.inputs.Telemetry.enabled then
            ctx.state.distance = ctx.state.distance + math.abs(ctx.inputs.Telemetry.speed) * dt
            ctx.set("Distance", ctx.state.distance)
        end
    end
}
