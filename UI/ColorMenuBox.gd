extends HBoxContainer

onready var palette_picker = $PalettePicker
onready var pal_pos_slider = $ColorPicker/PalettePositionSlider
onready var bright_slider = $VBoxContainer2/BrightnessSlider
onready var tex = $ColorPicker/Control/PaletteTexture
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const palettes: PaletteCollection = preload("res://Resources/palette_collection.tres")
const palette_material = preload("res://PaperCuts/palette_render_material.tres")

var current_layer = null

signal palette_changed(palette_graphic)

# Called when the node enters the scene tree for the first time.
func _ready():
	palette_material.connect("changed", self, "_on_palette_material_changed")
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

func _on_palette_material_changed():
	if tex != null:
		tex.texture = palette_material.get_shader_param("palette")
	pass


func _on_BrightnessSlider_value_changed(value):
	if current_layer != null:
		current_layer.brightness_add = value
	pass # Replace with function body.
