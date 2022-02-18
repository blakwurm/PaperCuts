extends HBoxContainer

onready var palette_picker = $PalettePicker
onready var pal_pos_slider = $ColorPicker/PalettePositionSlider
onready var tex = $ColorPicker/PaletteTexture
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const palettes: PaletteCollection = preload("res://Resources/palette_collection.tres")

var current_layer = null

signal palette_changed(palette_graphic)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_current_layer(layer_name, raw_layer):
	current_layer = raw_layer
	pal_pos_slider.value = raw_layer.palette_offset
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PalettePositionSlider_value_changed(value):
	if current_layer != null:
		current_layer.palette_offset = value
	pass # Replace with function body.


func _on_PalettePicker_ready():
	for palette in palettes.palettes:
		pass
	pass # Replace with function body.


func _on_ColorPickPopup_texture_selected(texture):
	tex.texture = texture
	pass # Replace with function body.
