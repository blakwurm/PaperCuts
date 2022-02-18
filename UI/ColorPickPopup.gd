extends WindowDialog

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const palettes: PaletteCollection = preload("res://Resources/palette_collection.tres")
onready var color_options = $ScrollContainer/ColorOptions
onready var texture_option_template = $TextureOption

signal texture_selected(texture)
# Called when the node enters the scene tree for the first time.
func _ready():
	build_color_options()
	pass # Replace with function body.

func build_color_options():
	for ch in color_options.get_children():
		color_options.remove_child(ch)
		ch.queue_free()
	for tx in palettes.palettes:
		print(tx)
		var option = texture_option_template.duplicate()
		color_options.add_child(option)
		option.texture = tx
		option.visible = true
		option.connect("texture_selected", self, "texture_selected")
	pass

func texture_selected(texture):
	emit_signal("texture_selected", texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PalettePicker_pressed():
	self.show()
	pass # Replace with function body.
