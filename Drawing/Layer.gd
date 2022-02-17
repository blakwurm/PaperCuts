extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var cuts = $Viewport/Cuts
onready var redo_queue = $RedoQueue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_cut(newcut: Node2D):
	if newcut != null:
		cuts.add_child(newcut)
		newcut.owner = cuts
		for child in redo_queue.get_children():
			child.queue_free()


