extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal add_mode_changed(new_add)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ClipperAddToggle_toggled(button_pressed):
	var val = 0
	if button_pressed:
		val = 1
	emit_signal("add_mode_changed", val)
	pass # Replace with function body.
