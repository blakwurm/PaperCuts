extends Resource

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name SavedPapercut

export var name = ""
export(Array, Array) var layers = []
export(int) var papercuts_version = 0
export(String) var artist
export(int) var art_version = 1
export(Image) var palette
export(float) var shadow_size = 0.009
export(int) var shadow_passes = 10
export(bool) var save_with_shader = false
export(bool) var save_with_pretty = false
export(bool) var save_with_raw = false

enum LAYER_DATA_IND {
	NAME, HEIGHT, PALETTE_OFFSET, PNG, NORMALIND
}

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
