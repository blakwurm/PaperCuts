extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var image = $Image

export(Texture) var texture setget set_texture

signal texture_selected(texture)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", self, "texture_press")
	pass # Replace with function body.

func set_texture(_tex):
	if _tex != null and image != null:
		texture = _tex
		image.texture = _tex

func texture_press():
	emit_signal("texture_selected", texture)
	pass
