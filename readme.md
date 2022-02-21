# PaperCuts

A simple art tool, for making paper cut art assets for the forthcoming game Oredont

## App Usage

Add a layer by clicking on the "+" buttons at the bottom. Adjust the layer's distanace off of the bottom using the slider. Adjust the color using the color slider.

Use the "Change Palette" menu to adjust which palette you're using. Palettes are 1-pixel-high png images, and custom palettes can be added by placing them in the folder opened from the palette menu. Check out https://lospec.com/palette-list for more palettes (download them as "PNG Image (1x)")

Undo/Redo work depending on which layer you have selected, and undo/redo cuts. Adding and removing layers are not handled with undo/redo.

When you save the piece, several images and a .shadowmat.tres shader texture will be generated. If a custom palette was used, that palette will be saved to the file.

Controls:
| Button | Action |
| ------ | ------ |
| Mouse| Move the clippers
| Mouse 1 | Cut
| Mouse 2 | Move the selected layer's cuts
| Mouse 3 | Pan
| Mouse Wheel | Zoom
| Ctrl/Cmd+Z | Undo Cut On Layer
| Ctrl/Cmd+Y | Redo Cut On Layer
| Ctrl/Cmd+S | Save the piece as a .papercut.tres file
| Ctrl/Cmd+Shift+S | Save-As
| Ctrl/Cmd+O | Open a .papercut.tres file

## For Use in Godot

This tool was designed to help make assets for a game using the Godot engine. Copying the res://PaperCuts directory into a Godot game project will allow for loading of .papercut.tres files, and contains the shader required for .shadowmat.tres materials to function.
