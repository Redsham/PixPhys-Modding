# PixPhys modding examples

Examples for the current `Modification.json` loader and Mod API 1–2. API 2 adds custom data channels, logic nodes, part nodes and saved Lua components. These examples require the corresponding PixPhys update; older released builds do not support this Lua API.

| Example | Runtime | Demonstrates |
| --- | --- | --- |
| [Industrial skins](Examples/Skins/IndustrialSkins) | Data-only skin pack | No-code editor, imported texture, editable collision and physical materials |
| [Beacon](Examples/CSharp/Beacon) | Trusted C# | Existing `Main(Modification)`, `Prop.Register`, Unity behaviour, saved fields and a context action |
| [Resource speaker](Examples/CSharp/ResourceSpeaker) | Trusted C# | Packaged sprite/audio resources and a context action |
| [Heat plate](Examples/Lua/HeatPlate) | Sandboxed Lua | Item registration, module loading, temperature, context action and persistent settings |
| [Pulse thruster](Examples/Lua/PulseThruster) | Sandboxed Lua | Owned object handles, fixed-step updates and physical forces |
| [Custom data bus](Examples/Lua/CustomDataBus) | Lua API 2 | Structured telemetry type, pack/unpack nodes, saved distance integrator |
| [Signal thruster](Examples/Lua/SignalThruster) | Lua API 2 | Part node, editable inputs, physical outputs and saved motor state |
| [Stateful components](Examples/Lua/StatefulComponents) | Lua API 2 | Multiple components per part, collision events and independent saved state |

[Skin editor](docs/Skin-Editor.md) · [Русская инструкция](README.ru.md) · [Lua API](docs/Lua-API.md) · [Руководство по Lua и нодам](docs/Lua-Modding.ru.md) · [Compatibility and security](docs/Compatibility.md)

## Install an example

1. Copy an individual example folder into `GameData/Modifications/`. Do not copy the whole repository into that folder.
2. Start PixPhys and open the modifications menu.
3. Choose **Review version**, inspect the runtime and permissions, then enable that version.
4. Find the item in the catalogue and spawn it. For CustomDataBus, open the construction's wiring editor and search for **Pack telemetry**, **Read telemetry** and **Telemetry distance counter**. That package adds nodes rather than physical items.

On Windows, GameData is normally beside the game installation. On macOS and Linux, use the GameData folder in the game's persistent data location. Local paths and Workshop subscriptions have separate identities.

New or changed content needs review. The game runs a verified snapshot and retains the previous approved version when an unapproved update arrives. If a version was already loaded, approving a different version requires a restart.

C# modifications run inside Unity with the player's process permissions. Approval and the code check do **not** sandbox C#. **Full C# compatibility** is an explicit grant for one package version to bypass the additional code filter. Use it only for code you have reviewed and trust. Publication requires a session without loaded C# modifications.

Lua modifications use a narrower API, with no host filesystem, process or Steam API access. The interpreter is embedded in Unity; instruction budgets do not provide a hard process memory limit or protection against interpreter/native decoder vulnerabilities.

## Authoring

`Runtime: "skin"` selects editable data-only skins; `Runtime: "csharp"` and `Runtime: "lua"` select script runtimes. Omitting Runtime retains the existing C# format. Scripts must be package-relative paths. Keep resources inside the example's folder; absolute paths, traversal, linked files and ambiguous filenames are rejected.

Keep registered C# prop identifiers and saved behaviour type/field names stable across versions. Lua prop identifiers are scoped by package identity: moving a local mod to a different folder or publishing it under a new Workshop ID changes that identity. See the compatibility document before moving or renaming a package.

`WorkshopID` is zero in every example. The game records the returned ID only after a successful publication. Do not use another author's ID. Publishing uploads a prepared copy, and construction uploads include only the supported save files.

Run `python3 tools/validate_examples.py` to check the package layout. Compilation and gameplay must also be checked in a compatible Unity project; the validator does not claim to certify code as safe.

The historical 0.1 examples are retained under [Archive/0.1](Archive/0.1). They use an obsolete API and are not templates for the current game. No compatibility adapters for those examples are installed by this repository.
