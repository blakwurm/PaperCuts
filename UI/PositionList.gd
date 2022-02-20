extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const layer_button = preload("res://UI/LayerButton.tscn")

onready var height_slider = $HBoxContainer/HeightSlider
onready var layer_buttons = $HBoxContainer/ScrollContainer/LayerButtons
var raw_items = {}
var selected_key = "" setget select_item_key

signal selected(key)
signal height_change(key, value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item(key: String, height: float):
	print(key)
	raw_items[key] = height
	print(raw_items)
	self.sort_items_by_height()
	self.selected_key = key

func remove_item(key):
	raw_items.erase(key)
	self.sort_items_by_height()

func select_item_key(_key):
	selected_key = _key
	height_slider.value = raw_items.get(_key, 0.0)
	for child in layer_buttons.get_children():
		child.pressed = child.layer_name == selected_key
	emit_signal("selected", _key)

func rename_selected_item(_new_name):
	var height = raw_items[selected_key]
	raw_items.erase(selected_key)
	raw_items[_new_name] = height
	sort_items_by_height()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func sort_items_by_height():
	var li = []
	for key in raw_items.keys():
		li.append([key, raw_items[key]])
	li.sort_custom(self, "_height_sort_fn")
	for child in layer_buttons.get_children():
		child.queue_free()
	for thingy in li:
		var btn = layer_button.instance()
		btn.layer_name = thingy[0]
		btn.pressed = btn.layer_name == selected_key
		btn.connect("layer_selected", self, "_on_layer_button_pressed")
		layer_buttons.add_child(btn)
	pass

static func _height_sort_fn(a, b):
	if a == null:
		return false
	elif b == null:
		return true
	return a[1] >= b[1]

func change_selected_height(_h: float):
	raw_items[self.selected_key] = _h
	sort_items_by_height()
	emit_signal("height_change", selected_key, _h)
	pass

func _on_layer_button_pressed(layername):
	self.selected_key = layername
	emit_signal("selected", layername)

func _on_VSlider_value_changed(value):
	change_selected_height(value)
	pass # Replace with function body.


func _on_UI_rename_selected_layer(new_name):
	self.rename_selected_item(new_name)
	self.sort_items_by_height()
	emit_signal("selected", new_name)
	pass # Replace with function body.
