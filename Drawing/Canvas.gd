extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export onready var selected_layer_name = "" setget set_selected_layer_name

const palette_material = preload("res://Drawing/palette_render_material.tres")
onready var render = $Render

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

func add_layer(layer_name: String = "", filled = true, height = null, palette_offset = null, backdata = null):
	if layer_name == "":
		layer_name = "%s" % random.randi()
	var layer = layer_scene.instance()
	layer.owner = layers
	layer.name = layer_name
	if layers.get_child_count() < 1:
		selected_layer_name = layer_name
	layers.add_child(layer)
	if height:
		layer.height = height
	if palette_offset:
		layer.palette_offset = palette_offset
	if backdata:
		layer.set_back(backdata)
	#layer.position = Vector2(size, size)
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



func save_current(filepath):
	var saved = SavedPapercut.new()
	saved.palette = palette_material.get_shader_param("palette").get_data()

	for child in layers.get_children():
		var txdata = child.get_node("Texture").texture.get_data()
		txdata.convert(Image.FORMAT_L8)
		var pn = txdata.save_png_to_buffer()
		#txdata.save_png("user://%s" % child.name)
		var ldata = [child.name, child.height, child.palette_offset, pn]
		saved.layers.append(ldata)
		pass
	saved.artist = "Zaphodious"
	saved.art_version = 0
	print(saved)
	var res = ResourceSaver.save(filepath, saved)#, ResourceSaver.FLAG_BUNDLE_RESOURCES + ResourceSaver.FLAG_CHANGE_PATH)
	print("should be saved now")

func load_thing(filepath, append=false):
	var res = load(filepath)
	print(res)
	var l = res.layers
	if !append:
		for lay in layers.get_children():
			layers.remove_child(lay)
			lay.queue_free()
			pass
	for lay in l:
		self.add_layer(lay[0], true, lay[1], lay[2], lay[3])
		#layers.add_child(lay.instance())
	var tx = ImageTexture.new()
	tx.create_from_image(res.palette, 0)
	var pal: Image = res.palette
	
	palette_material.set_shader_param("palette", tx)

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


func _on_UI_save_file(filepath):
	self.save_current(filepath)
	pass # Replace with function body.


func _on_UI_load_file(filepath):
	self.load_thing(filepath)
	pass # Replace with function body.
