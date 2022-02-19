extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export onready var selected_layer_name = "" setget set_selected_layer_name

const size = 2048

var random = RandomNumberGenerator.new()
const layer_scene = preload("res://Drawing/Layer.tscn")
onready var layers = $Layers
onready var removed_stack = $RemovedStack

signal layer_added(layer_name, layer_height)
signal layer_selected(layer_name, layer)

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	#var ln = add_layer()
	#if selected_layer_name == "":
	#	self.selected_layer_name = ln.name
	pass # Replace with function body.

func add_layer(layer_name: String = "", filled = true):
	if layer_name == "":
		layer_name = "%s" % random.randi()
	var layer = layer_scene.instance()
	layer.owner = layers
	layer.name = layer_name
	#layer.position = Vector2(size, size)
	if layers.get_child_count() < 1:
		selected_layer_name = layer_name
	layers.add_child(layer)
	layer.set_fill(filled)
	emit_signal("layer_added", layer_name, layer.height)
	return layer
	pass

func remove_layer(layer_name):
	var layer = layers.get_node(layer_name)
	removed_stack.add_child(layer)
	layer.owner = removed_stack
	if layers.get_child_count() < 1:
		self.selected_layer_name = self.add_layer().name

func undo_remove():
	var layer = removed_stack.get_child_count().pop_last()
	layers.add_child(layer)
	layer.owner = layers

func set_selected_layer_name(_sln: String):
	if layers.get_node(_sln) != null:
		selected_layer_name = _sln
	elif layers.get_child_count() > 0:
		selected_layer_name = layers.get_child(0)
	else:
		selected_layer_name = self.add_layer().name
	emit_signal("layer_selected", selected_layer_name, layers.get_node(selected_layer_name))
	pass

func get_selected_layer():
	return layers.get_node(selected_layer_name)

func set_height(_height):
	self.get_selected_layer().set_height(_height)
	pass

func set_palette_offset(_po):
	self.get_selected_layer().set_palette_offset(_po)
	pass

func add_cut(newcut: Node2D):
	if layers.get_child_count() < 1:
		return
	self.get_selected_layer().add_cut(newcut)

func undo_cut():
	self.get_selected_layer().undo_cut()

func redo_cut():
	self.get_selected_layer().redo_cut()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_UI_add_layer(filled):
	self.add_layer("", filled)
	pass # Replace with function body.


func _on_UI_layer_height_raised(layer_name, new_height):
	var node = layers.get_node(layer_name)
	if node != null:
		node.height = new_height
	pass # Replace with function body.


func _on_UI_layer_selected(layer_name):
	self.selected_layer_name = layer_name
	pass # Replace with function body.


func _on_PolygonDrawingCamera_move_cuts(delta):
	get_selected_layer().move_cuts(delta)
	pass # Replace with function body.


func _on_UI_del_selected_layer():
	self.remove_layer(selected_layer_name)
	pass # Replace with function body.


func _on_UI_dupe_selected_layer():
	pass # Replace with function body.


func _on_UI_rename_selected_layer(new_name):
	pass # Replace with function body.
