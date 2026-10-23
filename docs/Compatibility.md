# Compatibility and security contract

## Existing C# modifications

The current `Modification.json` schema, `Modifications.Modification`, `Resources.LoadSprite/LoadTexture/LoadSound`, `Prop.Register` and Unity components remain available. A single public static `Main(Modifications.Modification)` is the recommended entry point; a parameterless `Main()` is also supported. C# source remains compiled by Roslyn. Arbitrary MonoBehaviours are available only in this trusted runtime.

The serialized settings fields SuspiciousModifications and SuspiciousLua are retained for reading old preferences. They no longer grant global privileges. Full C# compatibility must be approved per version. Lua constructions, previews and Lua modifications use the same capability policy.

Paths outside the package, symbolic links, oversized content and silent replacement of a reviewed version are intentionally rejected. Runtime enable state is stored outside the package. `Meta.Apply()` on a loaded snapshot persists enable state instead of rewriting subscribed content. Authoring metadata is saved to the source after publication.

C# cannot be unloaded safely in an existing Unity process. Disabling a loaded legacy mod does not revoke code that already ran; restart to fully remove it. Native process isolation cannot preserve direct access to Unity MonoBehaviours and arbitrary game internals without porting those integrations to a message API.

## Updates and dependencies

The content hash includes package file paths and bytes, not just script timestamps. Approval is bound to both source identity and hash. Dependencies, if declared, have `Identity` and exact `Hash` fields, and must be installed, enabled and approved. Dependency cycles are rejected. Dependencies are not fetched or enabled automatically.

The current API does not expose another mod's Script, .NET objects or private files. A manifest dependency controls loading order and approved version; it is not a general cross-mod IPC API.

An unexpected process exit quarantines the versions recorded in its session journal. A normal exit clears the journal. To recover, inspect and review the quarantined packages. Launch with `-pixphys-safe-mode` or create `GameData/ModSecurity/SafeMode` to start without modifications. Remove the marker when ready to resume.

Previous packages are retained in `GameData/ModSecurity/Packages`. Save backups use the existing recovery interface. Backups and trust records are not protected against an already trusted C# mod with full process permissions.

## Limits

A package has at most 4096 files and 8192 entries, 32 MiB per file and 256 MiB total; an entry script is at most 1 MiB. Images are checked for bounded advertised dimensions before decoding. Lua modifications may register 128 props, hold 256 live object handles, issue 512 API commands per execution batch, spawn 16 objects per batch and queue 128 events. Persistent state has 64 KiB per key, 1 MiB per mod and at most 256 keys.

Lua time/instruction accounting includes nested coroutines. It is cooperative at interpreter yield points: long host/library calls, native decoder defects and managed-heap exhaustion require additional runtime/process isolation for stronger guarantees. C# has no equivalent execution limit in compatibility mode.

The optional signed revocation feed requires a public key provisioned with the game and a deployment/distribution process operated by the developer. This example repository supplies no production key or revocation server.
