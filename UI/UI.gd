extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal add_mode_changed(new_add)
signal layer_selected(layer_name)
signal layer_height_raised(layer_name, new_height)
signal add_layer(filled)

onready var layer_list = $Panel/VBoxContainer/LayerList

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


func _on_PositionList_height_change(key, value):
	emit_signal("layer_height_raised", key, value)
	pass # Replace with function body.


func _on_PositionList_selected(key):
	emit_signal("layer_selected", key)
	pass # Replace with function body.


func _on_AddFullButton_pressed():
	emit_signal("add_layer", true)
	pass # Replace with function body.


func _on_AddClearButton_pressed():
	emit_signal("add_layer", false)
	pass # Replace with function body.


func _on_Canvas_layer_added(layer_name, layer_height):
	layer_list.add_item(layer_name, layer_height)
	pass # Replace with function body.
