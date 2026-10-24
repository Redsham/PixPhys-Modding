# Industrial skins

Two editable item variants, with no scripts:

- **Hazard block**: packaged pixel texture, editable **Steel body** and **Hazard markings** layers, an eight-point collision outline, metal preset and explicit mass.
- **Rubber block**: green tint, unlit rendering, circle collision, custom friction, bounce and density.

Copy this folder into `GameData/Modifications`, review and enable it. Use **Edit skin modification** in the pack context menu to open the in-game editor. Changing this example needs no programming or JSON editing.

Open **Appearance → Edit texture** on Hazard block to work with its layers. Hide **Hazard markings** to reveal the steel below, then show it and select it to recolor the stripes. Try a rectangular selection with **M**, copy/paste with **Ctrl/Cmd+C/V**, move it with **V**, or add shapes with **L**, **U** and **Shift+U**. Applying keeps a normal PNG for the game and the editable `.skintex` source for later editing. Layer editing requires the matching PixPhys update; the flattened item texture remains unchanged.

[English guide](../../../docs/Skin-Editor.md) · [Русская инструкция](../../../docs/Skin-Editor.ru.md)
