# Item skin editor

Create item variants without writing code. Open **Modifications → Create → Open skin editor**, choose a built-in base item, and edit its parts in the separate in-game editor. The base item keeps its normal gameplay behaviour.

## Workflow

1. Enter a pack name and author. Use **Choose base item** to select the original item. Add more items with **+**; each has its own name, description and part settings.
2. In **Appearance**, import a PNG/JPEG, choose tint/opacity, scale, mirroring and visibility. Set pixels per world unit to adjust image size. Choose original, lit or unlit rendering; lit materials support imported normal maps. Imported files are copied into the package.
3. In **Collision**, keep the original shape or choose a box, circle, capsule, editable polygon or no solid collision. Edit dimensions and offsets numerically. Polygon vertices can be dragged; double click adds a vertex and right click removes one. **Outline from image** creates a convex hull of opaque pixels in an imported image. For concave shapes, edit the vertices afterwards.
4. In **Material**, enable an override, choose a game preset or enter custom friction, bounce, density, thermal, fire and electrical parameters. You can set mass explicitly; otherwise a material change adjusts mass for density and replacement collider area.
5. Use **Test drop** to check contact geometry. The preview uses a separate physics scene and geometry-only copies. Articulated items are approximated by one rigid body: motors, joints, fire and gameplay scripts do not run in the preview. Check full gameplay after saving.
6. **Save** writes a local modification. A new pack becomes available in the catalogue immediately. Updating an already loaded pack requires restarting the game. **Save a copy** creates a separate local package with Workshop ID zero.

Use the modification context menu to edit an existing skin pack or publish a saved package through the normal Workshop confirmation. Editing a Workshop pack produces a local copy. Incoming or changed packages still require version review; the editor approves the exact local version it has just authored.

Undo/redo keeps 32 actions; a polygon drag is one action. Saving clears history. Ctrl/Cmd+S saves, Ctrl/Cmd+Z undoes, Ctrl/Cmd+Y redoes, and Esc closes the current dialog or editor. Unsaved changes require Save, Discard or Keep editing before switching projects or closing.

## Example

Copy [IndustrialSkins](../Examples/Skins/IndustrialSkins) into `GameData/Modifications`, review and enable it. It adds **Hazard block** (a packaged texture and eight-point collider) and **Rubber block** (tint, circular collider and custom physical material). Open **Edit skin modification** to change either item without editing JSON. The matching PixPhys update is required.

## Data-only format

The package contains `Modification.json` with `Runtime: "skin"`, `ApiVersion: 1`, `Scripts: []`, an editable `Skin.json`, `Textures/`, per-item `Previews/` and `Thumbnail.png`. It cannot register arbitrary components, run scripts or write into another mod. Use Lua for new behaviour and logic nodes. Existing C# and Lua formats are unchanged.

Limits: 64 items, 64 configured parts per item, 3–64 vertices per polygon, 1 MiB skin document, 8 MiB per image, 8192 pixels per image side and 16 megapixels of decoded textures in the pack. Both filtering variants of an image count if used. Imported images held during an editing session are capped at 64 MiB. Self-intersecting polygons, unavailable base items, invalid part paths and non-finite parameters are rejected before saving.

Keep item IDs and package identity stable. Renaming a displayed item is safe; moving a local package or publishing under a different Workshop ID changes its identity. Existing constructions still require the original package. A base item's hierarchy can change after a game update; affected skins may need to select the base and configure parts again.

[Русская инструкция](Skin-Editor.ru.md) · [Compatibility](Compatibility.md)
