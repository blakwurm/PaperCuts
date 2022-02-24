# PaperCuts

A simple art tool, for making paper cut art assets for the forthcoming game Oredont

## App Usage

Add a layer by clicking on the "+" buttons at the bottom. Adjust the layer's distanace off of the bottom using the slider. Adjust the color using the horizontal color slider. The paper texture can be adjusted using the slider next to the color picker.

Use the "Change Palette" menu to adjust which palette you're using. Palettes are 1-pixel-high png images, and custom palettes can be added by placing them in the folder opened from the palette menu. Check out https://lospec.com/palette-list for more palettes (download them as "PNG Image (1x)")

Undo/Redo work depending on which layer you have selected, and undo/redo cuts. Adding and removing layers are not handled with undo/redo.

The palette being used will be embedded in the save file. Optionally, when saving the file several images and a .shadowmat.tres shader texture can be saved alongside the file.

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
| C | Toggle clippers between "add" and "remove" |

## For Use in Godot

This tool was designed to help make assets for a game using the Godot engine. Copying the res://PaperCuts directory into a Godot game project will allow for loading of .papercut.tres files, and contains the shader required for .shadowmat.tres materials to function.

## "Raw" PNGs

If enabled, the app will save ".raw.png" images alongside the save game. You can also export a raw png via the "export" button in the UI. This is the image that the app uses internaly in-between combining the layers and calculating color and shadows, and can be fairly straightforwardly as input to a custom shader.

The image's channels are:
- R: Color, spcificlly the UV (vec2(r,r)) of the color palette image. This works perfectly fine for 1-pixel-high palette images, but will probably yield undefined and interesting results if a higher-height image is used.
- G: Height, where 0 is lowest and 1 is highest. 
- B: Which normal map to use. In the shader, the value is multiplied by 12 and rounded, and used as the index.
- A: Alpha, unchanged
