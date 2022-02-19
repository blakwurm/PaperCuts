extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal add_mode_changed(new_add)
signal layer_selected(layer_name)
signal layer_height_raised(layer_name, new_height)
signal add_layer(filled)
signal del_selected_layer()
signal dupe_selected_layer()
signal rename_selected_layer(new_name)
signal resize_pen_leash(new_size)
signal set_cut_move_frac(new_frac)

onready var layer_list = $Panel/VBoxContainer/LayerList
onready var color_menu_box = $ItemList/ColorMenuBox

const view_material = preload("res://Drawing/palette_render_material.tres")

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


func _on_Canvas_layer_selected(layer_name, layer):
	color_menu_box.set_current_layer(layer_name, layer)
	pass # Replace with function body.


func _on_ColorPickPopup_texture_selected(texture):
	view_material.set_shader_param("palette", texture)
	pass # Replace with function body.


func _on_DelButton_pressed():
	emit_signal("del_selected_layer")
	pass # Replace with function body.


func _on_DupeButton_pressed():
	emit_signal("dupe_selected_layer")
	pass # Replace with function body.


func _on_SelectedNameBox_text_changed(new_text):
	emit_signal("rename_selected_layer", new_text)
	pass # Replace with function body.


func _on_SizeSpinner_value_changed(value):
	$Panel/VBoxContainer/HBoxContainer7/SizeSlider.value=value
	emit_signal("resize_pen_leash", value)
	pass # Replace with function body.


func _on_SizeSlider_value_changed(value):
	$Panel/VBoxContainer/HBoxContainer7/SizeSpinner.value=value
	emit_signal("resize_pen_leash", value)
	pass # Replace with function body.


func _on_CutMoveSpinner_value_changed(value):
	$Panel/VBoxContainer/HBoxContainer14/CutMoveSlider.value=value
	emit_signal("set_cut_move_frac", value)
	pass # Replace with function body.


func _on_CutMoveSlider_value_changed(value):
	$Panel/VBoxContainer/HBoxContainer14/CutMoveSpinner.value=value
	emit_signal("set_cut_move_frac", value)
	pass # Replace with function body.
