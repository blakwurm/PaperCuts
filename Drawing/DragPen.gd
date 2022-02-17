extends Position2D
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float, 0.0, 1.0, 0.1) var max_leash = 0.5 setget set_max_leash
export(int) var leash_distance = 128;

onready var border_graphic = $BorderGraphic
onready var pen = $Pen
# Called when the node enters the scene tree for the first time.
func _ready():
	pen.set_as_toplevel(true)
	pass # Replace with function body.

func set_max_leash(_new_leash: float):
	max_leash = _new_leash
	if border_graphic != null:
		border_graphic.material.set_shader_param("size", _new_leash)

func _physics_process(delta):
	if pen != null:
		var penpos = pen.global_position
		var thispos = self.global_position
		var distance_vec = (thispos - penpos)
		var distance = distance_vec.length()
		var max_distance = leash_distance * max_leash
		if distance > max_distance:
			pen.global_position = thispos - distance_vec.normalized()*leash_distance*max_leash
		pass

func get_pen_pos():
	return pen.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
