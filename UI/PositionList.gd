extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var items = $HBoxContainer/ItemList
onready var height_slider = $HBoxContainer/HeightSlider
var raw_items = {}
var selected_ind = 0 setget select_item_ind
var selected_key = "" setget select_item_key

signal selected(key)
signal height_change(key, value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item(key: String, height: float):
	print(key)
	items.add_item(key)
	raw_items[key] = height
	print(raw_items)
	self.sort_items_by_height()
	self.selected_key = key

func remove_item(key):
	var ind = items.items.bsearch(key)
	items.remove_item(ind)
	raw_items.erase(key)
	self.sort_items_by_height()
	
func select_item_ind(_ind):
	selected_ind = _ind
	items.select(_ind)
	selected_key = items.get_item_text(_ind)
	var height = raw_items.get(selected_key, 0.0)
	height_slider.value = height
	print("selected thing at ", _ind)

func select_item_key(_key):
	select_item_ind(items.items.bsearch(_key))

func rename_selected_item(_new_name):
	var height = raw_items[selected_key]
	raw_items.erase(selected_key)
	raw_items[_new_name] = height
	items.set_item_text(selected_ind, _new_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func sort_items_by_height():
	var li = []
	for key in raw_items.keys():
		li.append([key, raw_items[key]])
	li.sort_custom(self, "_height_sort_fn")
	items.clear()
	for thingy in li:
		items.add_item(thingy[0])
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

func _on_ItemList_item_selected(index):
	self.selected_ind = index
	emit_signal("selected", selected_key)
	pass # Replace with function body.


func _on_VSlider_value_changed(value):
	change_selected_height(value)
	pass # Replace with function body.
