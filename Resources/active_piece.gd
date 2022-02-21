extends Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name ActivePiece

export var name = ""
export var artist = ""
export var version = 0
export var from_saved = false
export(float) var shadow_size = 0.009
export(int) var shadow_passes = 10
export(bool) var save_with_shader = false
export(bool) var save_with_pretty = false
export(bool) var save_with_raw = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


