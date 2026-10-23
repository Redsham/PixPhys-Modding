# Lua Mod API 1

A package declares `Runtime: "lua"`, `ApiVersion: 1`, and its entry scripts in `Modification.json`. No raw Unity or .NET objects are exposed. Entry scripts register definitions; callbacks control instances through owned numeric handles.

## Registration

`Mod.Name`, `Mod.Version`, `Mod.ApiVersion` describe the package.

`Mod.RegisterProp({ id, base, name, description, thumbnail, onSpawn })` creates a catalogue definition derived from an existing prop such as `SmallMetalCube`. `id` contains letters, numbers, underscores or hyphens. `thumbnail` is an optional package-relative PNG/JPEG path. `onSpawn(handle)` runs when an instance is initialized, including restoration and icon preparation; do not assume this is a player placement event.

`Mod.OnTick(function(delta) ... end)` sets a fixed-simulation-step callback. Work can be deferred when the shared script CPU budget is exhausted. Do not use it as a wall-clock timer.

## World

All operations validate handle ownership. A handle from another mod or an expired handle cannot operate on an object. Use `World.Exists` before accessing stored handles.

| Function | Meaning |
| --- | --- |
| `World.Exists(handle)` | Whether this mod owns a live object |
| `World.State(handle)` | Table with x, y, vx, vy |
| `World.SetColor(handle, r, g, b, a=1)` | Set the root sprite color; color components are bounded to -1..1 |
| `World.SetSprite(handle, path)` | Load a sprite from this package |
| `World.SetMass(handle, kilograms)` | Set a positive Rigidbody2D mass |
| `World.SetTemperature(handle, degrees)` | Set temperature through the game's physical-object model |
| `World.ApplyForce(handle, x, y)` | Apply force on the simulation step |
| `World.SetVelocity(handle, x, y)` | Set a finite velocity, bounded to 10000 per component |
| `World.Spawn(id, x, y)` | Create this mod's registered prop and return its handle |
| `World.Destroy(handle)` | Remove an owned object |
| `World.OnUse(handle, label, callback)` | Add an item-context action |

World.Spawn creates a standalone simulation object. It does not silently add parts to an edited vehicle or register an undo operation. Use normal catalogue placement when a part must belong to a saved construction.

Callbacks are queued rather than recursively re-entering Lua through C#. The queue, commands and instruction budgets are bounded. A runtime error stops and quarantines the modification instead of repeatedly invoking the failing callback.

## Modules and state

`require("settings")` loads `settings.lua` from this verified package. Dotted names map to subfolders. Recursive module imports and host filesystem loaders are rejected.

`Storage.Get(key)` returns a stored string or nil. `Storage.Set(key, string)` persists a value in this mod's separate state directory. Keys are 1..64 letters, numbers, underscores or hyphens. State is per package identity and shared across instances and versions; it is not an arbitrary file API or a serialization hook for each instance.

Lua source inside an existing processor/display retains the established Input/Output/UI APIs. That construction scripting interface is separate from the Mod/World/Storage package API.
