extends Sprite
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var height: float = 0.0 setget set_height
export var palette_offset: float = 0.0 setget set_palette_offset
export var normal_chan: float = 0.0 setget set_normal_chan

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.modulate = Color(1.0,0.5,1.0,1.0)
	pass # Replace with function body.

func set_height(nh):
	height = nh
	var sm = self.modulate
	self.modulate.r = nh
	self.z_index = 100*nh

func set_palette_offset(po):
	palette_offset = po
	self.modulate.g = po

func set_normal_chan(nc):
	normal_chan = nc
	self.modulate.b = nc

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
