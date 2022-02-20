extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var layer_name = "" setget set_layer_name

signal layer_selected(layername)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_layer_name(_ln):
	layer_name = _ln
	self.text = _ln


func _on_LayerButton_pressed():
	emit_signal("layer_selected", layer_name)
	pass # Replace with function body.
