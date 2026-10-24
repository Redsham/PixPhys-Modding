# Item skin editor

Create optional artwork variants without writing code. Skin packs add choices to **Toybox > Skin**, including **Original**, rather than registering separate catalogue parts. Different quick slots can use different skins for the same base part. Open **Modifications → Create → Open skin editor**, choose a built-in base item, and edit its parts in the separate in-game editor. The base item keeps its normal gameplay behaviour.

## Workflow

1. Enter a pack name and author. Use **Choose base item** to select the original item. Add more skin variants with **+**; each has its own name, description and part settings.
2. In **Appearance**, import a PNG/JPEG, choose tint/opacity, scale, mirroring and visibility. Set pixels per world unit to adjust image size. Choose original, lit or unlit rendering; lit materials support imported normal maps. Imported files are copied into the package.
3. In **Collision**, keep the original shape or choose a box, circle, capsule, editable polygon or no solid collision. Edit dimensions and offsets numerically. Polygon vertices can be dragged; double click adds a vertex and right click removes one. **Outline from image** creates a convex hull of opaque pixels in an imported image. For concave shapes, edit the vertices afterwards.
4. In **Material**, enable an override, choose a game preset or enter custom friction, bounce, density, thermal, fire and electrical parameters. You can set mass explicitly; otherwise a material change adjusts mass for density and replacement collider area.
5. Use **Test drop** to check contact geometry. The preview uses a separate physics scene and geometry-only copies. Articulated items are approximated by one rigid body: motors, joints, fire and gameplay scripts do not run in the preview. Check full gameplay after saving.
6. **Save** writes a local modification. New variants become available in Toybox immediately. Saving an already loaded skin pack refreshes artwork without restarting. Existing constructions keep their saved physical settings; new placements use the current variant. **Save a copy** creates a separate package with a fresh ProjectId and Workshop ID zero.

Use the modification context menu to edit an existing skin pack or publish a saved package through the normal Workshop confirmation. Editing a Workshop pack produces a local copy. Incoming or changed packages still require version review; the editor approves the exact local version it has just authored.

Undo/redo keeps 32 actions; a polygon drag is one action. Saving clears history. Ctrl/Cmd+S saves, Ctrl/Cmd+Z undoes, Ctrl/Cmd+Y redoes, and Esc closes the current dialog or editor. Unsaved changes require Save, Discard or Keep editing before switching projects or closing.

## Example

Copy [IndustrialSkins](../Examples/Skins/IndustrialSkins) into `GameData/Modifications`, review and enable it. Choose Small Metal Cube in Toybox and select **Hazard block** (a packaged texture and eight-point collider) or **Rubber block** (tint, circular collider and custom physical material) in its Skin list. Open **Edit skin modification** to change either item without editing JSON. The matching PixPhys update is required.

## Pixel snapping and precise vertex insertion

**Snap vertices to pixels** is enabled by default. Dragged vertices and numerical coordinate edits align to sprite pixel boundaries, accounting for the sprite pivot. Existing vertices are unchanged when the setting is enabled. Disable it for free placement. Zoom in to see the pixel grid.

Double click near the desired edge to insert a vertex at that position. A click in empty space does not modify the polygon. The inserted point remains exactly on the edge; on diagonals, snapping aligns its dominant coordinate to a pixel boundary without changing the edge shape. A complete drag remains one undo action.

## Built-in texture editor

Open **Appearance → Edit texture** to draw over the current sprite without changing its original asset. Use Pencil, Eraser, Fill and Pick color, select RGBA or a hex color, and set the brush size in pixels. Right click temporarily erases, the middle button pans, and the wheel zooms around the pointer. The checkerboard shows transparency; the pixel grid can be switched off.

The compact workspace puts a 64-color palette on the left, the canvas in the center, one column of pixel tool icons on the right and a layer table below the canvas. Hover a tool to see its name and shortcut in the status bar. Saturation/value, hue, the current color, hex and alpha stay below the palette, using an inline mode of the existing game Color Picker. Swatches synchronize the color without adding drawing history. Brush size, undo, redo, fit, grid, texture dimensions and resize actions are in the top context bar. The checkerboard is limited to the image; the surrounding canvas is a solid color. The pixel grid is off by default.

**Resize, keep pixels** preserves existing pixels from the top-left corner. **New transparent canvas** creates a blank image with the entered dimensions. Both operations support undo. Texture history keeps 32 operations and up to 64 MiB of pixel snapshots; one continuous stroke is one operation. Ctrl/Cmd+Z and Ctrl/Cmd+Y operate on this history while the texture editor is open.

Drawing stays in a working copy until **Apply to skin**. Closing changed artwork offers Apply, Discard or Keep editing. Applying creates an owned PNG and one undoable skin-document edit; the original image and built-in item stay unchanged. Resizing preserves the skin's world width and keeps its collision settings. Save the skin pack afterwards to persist it to disk.

## Layers, selections and shapes

The layer panel is below the canvas. Rows at the top render above lower rows. Select a row to paint on it, toggle visibility, or use Add, Duplicate, Delete, Up, Down and Merge down. Separate eye and lock columns change any layer without changing the active selection. Set the selected layer's name and opacity in percent below the list. Hidden and locked layers cannot be painted on. Duplicates own independent pixels.

Drag a layer by its name to change its order. A yellow insertion line previews the destination; dragging near the top or bottom of a long list auto-scrolls. Dropping outside the list or pressing Esc cancels. A completed drag is one undo/redo operation.

Double-click a name to rename it inline: Enter or clicking outside commits, while Esc cancels. Empty names and names longer than 64 characters are rejected. Right-click a layer for New, Duplicate, Rename, Delete, Merge down, Move up/down, Show/hide and Lock/unlock. Unavailable operations are disabled; Esc or clicking outside dismisses the menu without changing artwork.

The interface uses the game palette: dark panels, light text and a yellow accent. The palette swatch colors are preserved.

The workspace allows up to 32 layers within a total of 16 megapixels across all layers. Resizing preserves the top-left corner of every layer. New transparent canvas starts with one empty layer; undo restores the previous stack.

Applying and saving keeps an editable `Sources/<hash>.skintex` file alongside the flattened PNG. Reopening restores names, ordering, visibility, locks, opacity and pixels. Gameplay uses the ordinary PNG. Importing a replacement image or choosing the original texture replaces the layered artwork; the document undo can restore it before saving.

The rectangular selection limits painting, erasing, filling and shapes to the selected pixels on the active layer. Copy uses that layer; Ctrl/Cmd+Shift+C copies the visible composite. Cut, paste and Delete preserve alpha. The internal pixel clipboard is shared between texture-editor windows during the current game run. Paste uses the selected position or the canvas center, clips to the canvas, and selects the Move tool.

Drag inside the selection with Move to shift its pixels. Arrow keys move by one pixel; Shift+arrows move by ten. Deselect or Ctrl/Cmd+D removes the selection. Ctrl/Cmd+A selects the canvas.

Line, Rectangle, Ellipse and filled variants preview while dragging and commit as one undo operation. Shift constrains a square/circle or snaps the line angle to 45-degree steps. Ctrl/Cmd draws rectangle/ellipse shapes from the center. Escape first cancels a gesture, then clears a selection, then closes the editor.

The existing game HSV/RGBA Color Picker opens from the current-color swatch. It includes saturation/value, hue, RGB, alpha and hex. Changes update the brush color live; Cancel restores the original color without adding pixel history.

## Keyboard shortcuts

The main tool defaults follow [Aseprite drawing tools](https://www.aseprite.org/docs/drawing/) and [drawing modifiers](https://www.aseprite.org/docs/keyboard-shortcuts/). They apply inside the texture workspace and are suppressed while editing text or using the color dialog.

| Shortcut | Action |
| --- | --- |
| B (also P), E, G, I | Pencil, eraser, fill, eyedropper |
| M, V, L, H | Marquee, move selection, line, pan |
| U / U again | Rectangle / filled rectangle |
| Shift+U / Shift+U again | Ellipse / filled ellipse |
| Alt+click, Space+drag | Temporary eyedropper, temporary pan |
| Ctrl/Cmd+C, X, V | Copy, cut, paste |
| Ctrl/Cmd+Shift+C | Copy visible composite |
| Ctrl/Cmd+A, D | Select all, deselect |
| Delete / Backspace | Clear selected pixels on the active layer |
| Ctrl/Cmd+Shift+N, Ctrl/Cmd+J | New layer, duplicate layer |
| [ / ], minus / plus | Smaller / larger brush |
| 1–6 | 100–600% zoom |
| Ctrl/Cmd+' | Toggle pixel grid |
| Ctrl/Cmd+Z, Ctrl/Cmd+Shift+Z (also Ctrl/Cmd+Y) | Undo, redo |
| Enter, Escape | Finish; cancel gesture / deselect / close |
| Ctrl/Cmd+S | Apply artwork to the skin |

Pixel edits and layer operations share one history of 32 operations and up to 64 MiB of snapshots and retained buffers.


## Data-only format

The package contains `Modification.json` with `Runtime: "skin"`, `ApiVersion: 1`, `Scripts: []`, an editable `Skin.json`, `Textures/`, optional editable `Sources/*.skintex`, per-item `Previews/` and `Thumbnail.png`. The additive `LayerSource` part field links the source to the flattened image; old skins without it open as one layer. It cannot register arbitrary components, run scripts or write into another mod. Use Lua for new behaviour and logic nodes. Existing C# and Lua formats are unchanged.

Limits: 64 items, 64 configured parts per item, 3–64 vertices per polygon, 1 MiB skin document, 8 MiB per image, 8192 pixels per image side and 16 megapixels of decoded textures in the pack. Both filtering variants of an image count if used. Imported images held during an editing session are capped at 64 MiB. Self-intersecting polygons, unavailable base items, invalid part paths and non-finite parameters are rejected before saving.

Keep ProjectId and variant Id values stable. Renaming a variant is safe. A construction stores its ordinary base PropID, optional skin identity and a bounded snapshot of collision, scale and physical settings. Artwork is matched by ProjectId, variant Id and the Workshop source when present, so moving a local directory or installing the same pack through Workshop does not create a separate base part. Ambiguous copies are not selected at random. A base item's hierarchy can change after a game update; affected skins may need to select the base and configure parts again.

Editable sources are limited to 32 MiB, 32 layers and 16 megapixels across their layers, with at most 8 MiB per internal PNG. A separate 16-megapixel editable-layer quota applies across the whole pack. Names, dimensions and block lengths are validated before decoding. The flattened image remains a normal PNG and skin document version stays 1.

[Русская инструкция](Skin-Editor.ru.md) · [Compatibility](Compatibility.md)

## Optional artwork and missing construction parts

Skin packs are optional for Workshop constructions. Without a pack, the complete construction opens using the original artwork while preserving its saved collision, mass, material and scale. Installing and enabling the matching reviewed pack restores artwork on loaded parts without applying physics twice. OptionalSkins in Vehicle.json is separate from RequiredParts and does not make a texture pack a required part dependency.

If actual parts or logic nodes are unavailable, the load dialog lists them and offers Cancel or Open incomplete copy. An incomplete copy omits missing items and their joints, wires and service connections; it does not overwrite the source and requires Save As in the workbench. Known publications have Workshop links. Downloaded modifications still use the normal approval flow.

Construction save version 2 adds optional Skin references and keeps mod component payloads separate from the part list, allowing unavailable mod parts to be skipped without executing their code. Versions 0 and 1 remain readable. Old saves referring to separately registered skin items migrate when opened with the original skin pack installed; the next save stores the ordinary base part and optional skin. Without that old pack, the old format has no base-part metadata, so the entry appears in the missing-parts list. Skin.json remains version 1, and existing packs do not need manual conversion.
