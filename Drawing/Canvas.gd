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

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	var ln = add_layer()
	if selected_layer_name == "":
		self.selected_layer_name = ln.name
	pass # Replace with function body.

func add_layer(layer_name: String = ""):
	if layer_name == "":
		layer_name = "%s" % random.randi()
	var layer = layer_scene.instance()
	layer.owner = layers
	layer.name = layer_name
	#layer.position = Vector2(size, size)
	layers.add_child(layer)
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
	self.get_selected_layer().add_cut(newcut)

func undo_cut():
	self.get_selected_layer().undo_cut()

func redo_cut():
	self.get_selected_layer().redo_cut()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
