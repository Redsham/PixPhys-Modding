# Lua Mod API 1–2

A package declares `Runtime: "lua"`, `ApiVersion: 2`, and its entry scripts in `Modification.json`. Existing API 1 packages remain supported. `Mod.ApiVersion` reports the API supported by the host. No raw Unity or .NET objects are exposed. Entry scripts register definitions; callbacks control instances through owned numeric handles.

For a complete walkthrough in Russian, see [Lua modding, data types and nodes](Lua-Modding.ru.md).

## Registration

`Mod.Name`, `Mod.Version`, `Mod.ApiVersion` describe the package.

`Mod.RegisterProp({ id, base, name, description, thumbnail, onSpawn, node, components })` creates a catalogue definition derived from an existing prop such as `SmallMetalCube`. `id` contains letters, numbers, underscores or hyphens. `thumbnail` is an optional package-relative PNG/JPEG path. `onSpawn(handle)` runs when an instance is initialized, including restoration and icon preparation; do not assume this is a player placement event. Optional `node` refers to a registered part node; `components` is an array of this package's registered component IDs. Registration returns the prop's local ID.

`Mod.OnTick(function(delta) ... end)` sets a fixed-simulation-step callback. Work can be deferred when the shared script CPU budget is exhausted. Do not use it as a wall-clock timer.

## World

All operations validate handle ownership. A handle from another mod or an expired handle cannot operate on an object. Use `World.Exists` before accessing stored handles.

| Function | Meaning |
| --- | --- |
| `World.Exists(handle)` | Whether this mod owns a live object |
| `World.State(handle)` | Table with x, y, vx, vy, rotation (degrees), angularVelocity (degrees/second), mass, temperature |
| `World.SetColor(handle, r, g, b, a=1)` | Set the root sprite color; color components are bounded to -1..1 |
| `World.SetSprite(handle, path)` | Load a sprite from this package |
| `World.SetMass(handle, kilograms)` | Set a positive Rigidbody2D mass |
| `World.SetTemperature(handle, degrees)` | Set temperature through the game's physical-object model |
| `World.ApplyForce(handle, x, y)` | Apply force on the simulation step |
| `World.SetVelocity(handle, x, y)` | Set a finite velocity, bounded to 10000 per component |
| `World.Spawn(id, x, y)` | Create this mod's registered prop and return its handle |
| `World.Destroy(handle)` | Remove an owned object |
| `World.OnUse(handle, label, callback)` | Add an item-context action |
| `World.ApplyTorque(handle, torque)` | Apply 2D torque |
| `World.ApplyImpulse(handle, x, y)` | Apply a finite impulse |
| `World.SetAngularVelocity(handle, degreesPerSecond)` | Set angular velocity, bounded to 10000 |
| `World.SetGravityScale(handle, scale)` | Set gravity multiplier, bounded to -100..100 |
| `World.SetPosition(handle, x, y)` | Move an owned object |
| `World.SetRotation(handle, degrees)` | Rotate an owned object |
| `World.PlaySound(handle, path)` | Play packaged audio on the object |
| `World.Ports(handle)` | Array of port descriptors: id, name, direction, type |
| `World.ReadPort(handle, idOrName)` | Read a port as a Lua scalar, vector, composite or typed record |
| `World.WritePort(handle, idOrName, value)` | Write an owned part's port through the normal signal system |
| `World.OnPort(handle, idOrName, function(value) ... end)` | Observe a part port's runtime value changes |

World.Spawn creates a standalone simulation object. It does not silently add parts to an edited vehicle or register an undo operation. Use normal catalogue placement when a part must belong to a saved construction.

Callbacks are queued rather than recursively re-entering Lua through C#. The queue, commands and instruction budgets are bounded. A runtime error stops and quarantines the modification instead of repeatedly invoking the failing callback.

Port access requires a part linked to a construction. New part ports retain the base part's ports and append their own. Prefer stable port IDs over translated display names. `World.OnPort` does not emit an initial event; use `World.ReadPort` for the current value.

## Custom data types

`Mod.RegisterDataType({ id, default, fields, color })` returns a stable, package-scoped type ID. `default` is a table; `fields` is an optional map of required field names to `number`, `boolean`, `string`, `vector` or `table`. Additional fields and nested plain tables are allowed. `color` is optional `{r, g, b}` in 0..1. The default must satisfy the schema.

`Types.New(id, overrides)` returns an independent copy of the defaults with the supplied fields replaced. `Types.Is(value, id)` tests its type identity. The reserved `__type` string identifies a record. Typed values are copied and validated at the wire boundary; mutating a received table never changes the sender's value. Functions, threads, metatables, userdata, cycles, nonfinite numbers and host references cannot be stored in a signal or saved state.

Example: `local Command = Mod.RegisterDataType { id="Command", fields={power="number"}, default={power=0} }`; use `type=Command` in a port definition and send `Types.New(Command, {power=0.5})`.

## Nodes and components

All three registration calls return persistent IDs:

| Registration | Integration |
| --- | --- |
| `Mod.RegisterNode(definition)` | A standalone node in the ordinary node palette and search |
| `Mod.RegisterPropNode(definition)` | Ports and logic attached through `RegisterProp.node` |
| `Mod.RegisterComponent(definition)` | Reusable part behaviour attached through `RegisterProp.components`; no ports |

A definition has `id`, `name`, optional `description`, `category`, `inputs`, `outputs`, `state` and callbacks. Categories are `Utils`, `String`, `Logic`, `Math`, `Vector`, `Comparison`, `Composite`, `Trigonometry`. Ports are ordered arrays of `{id, name?, description?, type, default?}`. IDs must be unique across inputs and outputs. Types are `boolean`, `number`, `string`, `vector`, `composite`, or the ID returned by RegisterDataType. Each direction supports up to 64 ports.

| Callback | Invocation |
| --- | --- |
| `onInit(ctx)` | Once per instance initialization, after state and ports are restored |
| `onInput(ctx, portId, value)` | Runtime input change; ctx.inputs contains the current inputs |
| `onTick(ctx, dt)` | Fixed simulation step; skipped in construction editing mode |
| `onUse(ctx)` | A part context action named after its node/component |
| `onCollision(ctx, collision)` | Part collision enter: speed, vx, vy, and first contact x, y, nx, ny |
| `onDestroy(ctx)` | Instance removal during simulation; do not assume it runs on process termination |

Part-only callbacks are onUse and onCollision. Callbacks share the package's execution budget. During destruction, output writes from a destroyed independent node are refused.

`ctx.state` is a separate table per node/component, automatically saved with the construction. Mutate it or replace it with another plain table. `ctx.inputs[portId]` contains the latest input value. `ctx.set(outputId, value)` publishes an output. Use this function with **dot syntax**, not a colon. `ctx.object` is an owned physical-object handle for part definitions, or 0 for standalone nodes. `ctx.restored` distinguishes a restored state from a fresh instance. `ctx.editing` indicates construction editing during initialization/input callbacks. Treat inputs and the remaining context fields as host-owned.

State is limited to 64 KiB, 4096 values and 16 table levels per instance. It preserves string/number/boolean keys, arrays and nested tables. Components remain dormant on standalone objects until those objects are linked to a construction. Use normal catalogue placement for parts that must be saved.

Register types first, then nodes/components, then props that reference them. A prop can have one appended part-node definition and up to 32 separate components. One component definition can be reused by many prop definitions.

## Save compatibility

Keep package identity, definition IDs, port IDs, port order, directions and data types stable across updates. Changing a display name is safe. Saved custom channels resolve by persistent type ID even if mod loading order changes. Instances save plain state and references to installed definitions; they never embed executable module code. The approved mod must be installed to restore its nodes and parts.

An incompatible port layout is rejected explicitly rather than silently reconnecting a saved wire to a different input. Keep old definitions alongside replacements when changing a schema. In onInit, migrate old state fields using ctx.restored and your own state.version. See the Russian walkthrough for a migration pattern and example wiring recipes.

## Modules and state

`require("settings")` loads `settings.lua` from this verified package. Dotted names map to subfolders. Recursive module imports and host filesystem loaders are rejected.

`Storage.Get(key)` returns a stored string or nil. `Storage.Set(key, string)` persists a value in this mod's separate state directory. Keys are 1..64 letters, numbers, underscores or hyphens. State is per package identity and shared across instances and versions; it is not an arbitrary file API or a serialization hook for each instance.

Lua source inside an existing processor/display retains the established Input/Output/UI APIs. That construction scripting interface is separate from the Mod/World/Storage package API.
