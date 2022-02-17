extends Sprite
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float, 0.0, 1.0) var height = 0.5 setget set_height
export(float, 0.0, 1.0) var palette_offset = 0.5 setget set_palette_offset

onready var cuts = $Viewport/Cuts
onready var redo_queue = $RedoQueue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_height(_height):
	height = _height
	self.material.set_shader_param("height", _height)
	pass

func set_palette_offset(_po):
	palette_offset = _po
	self.material.set_shader_param("palette_offset", _po)
	pass

func add_cut(newcut: Node2D):
	if newcut != null:
		cuts.add_child(newcut)
		newcut.owner = cuts
		for child in redo_queue.get_children():
			child.queue_free()

func undo_cut():
	if cuts.get_child_count() > 0:
		var children: Array = cuts.get_children()
		var last = children.pop_back()
		redo_queue.add_child(last)
		last.owner = redo_queue

func redo_cut():
	if redo_queue.get_child_count() > 0:
		var children: Array = redo_queue.get_children()
		var last = redo_queue.pop_back()
		cuts.add_child(last)
		last.owner = cuts


