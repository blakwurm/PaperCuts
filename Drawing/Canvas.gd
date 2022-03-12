extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export onready var selected_layer_name = "" setget set_selected_layer_name

const palette_material = preload("res://PaperCuts/palette_render_material.tres")
const active_piece = preload("res://Resources/ActivePiece.tres")
const scene_export_template = preload("res://Resources/SceneExportTemplate.tscn")
const export_layer_template = preload("res://PaperCuts/ExportLayer.tscn")
onready var render = $Render
onready var normal_render = $NormalRender
onready var pre_color_and_shadow = $Renderer/ShadowProcessing

const size = 2048

var random = RandomNumberGenerator.new()
const layer_scene = preload("res://Drawing/Layer.tscn")
const random_word_list = preload("res://Resources/word_list.tres")
onready var layers = $Layers
onready var removed_stack = $RemovedStack

signal layer_added(layer_name, layer_height)
signal layer_selected(layer_name, layer)
signal layer_removed(layer_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	random_word_list.rand = random
	active_piece.connect("changed", self, "_on_active_piece_change")
	#var ln = add_layer()
	#if selected_layer_name == "":
	#	self.selected_layer_name = ln.name
	pass # Replace with function body.

func add_layer(layer_name: String = "", filled = true, height = null, palette_offset = null, backdata = null, normalind = 0.0):
	if layer_name == "":
		var exists = true
		while exists:
			var n = random_word_list.get_random_animal()
			if !layers.has_node(n):
				layer_name = n
				exists = false
	var layer = layer_scene.instance()
	layer.owner = layers
	layer.name = layer_name
	#layer.brightness_add = 0.5
	if layers.get_child_count() < 1:
		selected_layer_name = layer_name
	layers.add_child(layer)
	if height:
		layer.height = height
	if palette_offset:
		layer.palette_offset = palette_offset
	if backdata:
		layer.set_back(backdata)
	layer.brightness_add = normalind
	#layer.position = Vector2(size, size)
	layer.set_fill(filled)
	emit_signal("layer_added", layer_name, layer.height)
	return layer
	pass

func remove_layer(layer_name):
	var layer = layers.get_node(layer_name)
	if layer == null:
		return
	layers.remove_child(layer)
	layer.queue_free()
	emit_signal("layer_removed", layer_name)
	#if layers.get_child_count() < 1:
	#	self.selected_layer_name = self.add_layer().name

func undo_remove():
	var layer = removed_stack.get_child_count().pop_last()
	layers.add_child(layer)
	layer.owner = layers

func set_selected_layer_name(_sln: String):
	if layers.get_node(_sln) != null:
		selected_layer_name = _sln
	elif layers.get_child_count() > 0:
		selected_layer_name = layers.get_child(0).name
	else:
		selected_layer_name = self.add_layer().name
	emit_signal("layer_selected", selected_layer_name, layers.get_node(selected_layer_name))
	pass

func rename_selected_layer(_name: String):
	var layer = layers.get_node(selected_layer_name)
	layer.name = _name
	selected_layer_name = _name
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



func save_current(filepath: String):
	var saved: SavedPapercut = SavedPapercut.new()
	if ResourceLoader.exists(filepath):
		#var folderpathcont = filepath.split("/")
		#folderpathcont.remove(folderpathcont.size()-1)
		#var folderpath = folderpathcont.join("/")
		#var d = Directory.new()
		#d.open(folderpath)
		#var err = d.remove(filepath)
		#print("save error is ", err)
		saved = ResourceLoader.load(filepath)
		saved.layers = []
	ResourceSaver.save(filepath, saved)
	var imgparam = palette_material.get_shader_param("palette")
	if imgparam != null:
		saved.palette = imgparam.get_data()

	for child in layers.get_children():
		var txdata = child.get_node("Texture").texture.get_data()
		txdata.convert(Image.FORMAT_L8)
		var pn = txdata.save_png_to_buffer()
		#txdata.save_png("user://%s" % child.name)
		var ldata = [child.name, child.height, child.palette_offset, pn, child.brightness_add]
		saved.layers.append(ldata)
		pass
	saved.name = active_piece.name
	saved.artist = active_piece.artist
	saved.art_version = active_piece.version
	saved.shadow_passes = active_piece.shadow_passes
	saved.shadow_size = active_piece.shadow_size
	saved.save_with_pretty = active_piece.save_with_pretty
	saved.save_with_raw = active_piece.save_with_raw
	saved.save_with_shader = active_piece.save_with_shader
	saved.save_with_scene = active_piece.save_with_scene
	saved.export_size = active_piece.export_size
	var dir = Directory.new()
	dir.remove(filepath)
	var res = ResourceSaver.save(filepath, saved)#, ResourceSaver.FLAG_BUNDLE_RESOURCES + ResourceSaver.FLAG_CHANGE_PATH)
	if active_piece.save_with_scene:
		self.export_scene(filepath.replace(".papercut.tres", ".cutscene.scn"))
	if active_piece.save_with_pretty:
		self.export_image(filepath.replace(".papercut.tres", ".pretty.png"))
		self.export_normal(filepath.replace(".papercut.tres", ".normal.png"))
	if active_piece.save_with_raw:
		self.export_raw_image(filepath.replace(".papercut.tres", ".raw.png"))
	if active_piece.save_with_shader:
		var exported_mat = ShaderMaterial.new()
		exported_mat.shader = load("res://PaperCuts/palette_rendder_shader.gdshader")
		var tx = ImageTexture.new()
		tx.create_from_image(saved.palette, 0)
		exported_mat.set_shader_param("palette", tx)
		exported_mat.set_shader_param("shadow_passes", saved.shadow_passes)
		exported_mat.set_shader_param("shadow_amount", saved.shadow_size)
		ResourceSaver.save(filepath.replace(".papercut.tres", ".shadowmat.tres"), exported_mat)
	active_piece.from_saved = true

func load_thing(filepath, append=false):
	var res = load(filepath)
	var l = res.layers
	if !append:
		for lay in layers.get_children():
			layers.remove_child(lay)
			lay.queue_free()
			pass
	for lay in l:
		self.add_layer(lay[0], true, lay[1], lay[2], lay[3], lay[4])
		#layers.add_child(lay.instance())
	var tx = ImageTexture.new()
	tx.create_from_image(res.palette, 0)
	var pal: Image = res.palette
	
	palette_material.set_shader_param("palette", tx)
	palette_material.emit_changed()
	active_piece.name = res.name 
	active_piece.artist = res.artist
	active_piece.version = res.art_version
	active_piece.shadow_passes = res.shadow_passes
	active_piece.shadow_size = res.shadow_size
	active_piece.save_with_pretty = res.save_with_pretty
	active_piece.save_with_raw = res.save_with_raw
	active_piece.save_with_shader = res.save_with_shader
	active_piece.export_size = res.export_size
	active_piece.save_with_scene = res.save_with_scene
	active_piece.from_saved = true
	active_piece.emit_changed()

func export_scene(filepath):
	#var dir = Directory.new()
	#dir.open(folderpath)
	#dir.change_dir("../")
	#var err = dir.make_dir_recursive(folderpath)
	#print("create dir err ", err, " ", folderpath)
	var saved_layers = Node2D.new()
	saved_layers.name="layers"
	saved_layers.owner = saved_layers
	var packed = PackedScene.new()
	
	for child in layers.get_children():
		var newtx = ImageTexture.new()
		newtx.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
		var img: Image = child.get_node("Texture").texture.get_data()
		img.convert(Image.FORMAT_L8)
		var newsize = get_export_pixel_size()
		img.resize(newsize,newsize, Image.INTERPOLATE_NEAREST)
		newtx.create_from_image(img, 0)
		var l = export_layer_template.instance()
		l.height = child.height
		l.palette_offset = child.palette_offset
		l.normal_chan = child.brightness_add
		l.name = child.name
		l.texture = newtx
		saved_layers.add_child(l)
		print(saved_layers.get_children())
		l.owner = saved_layers
		#print("writing layer here")
		#var err = ResourceSaver.save(folderpath+"/"+child.name+".res", newtx, ResourceSaver.FLAG_COMPRESS)
		#print("save error is ", err)
		pass
	var packerr = packed.pack(saved_layers)
	print("packedchild:",packed.instance().get_children())
	var dir = Directory.new()
	var delthing = dir.remove(filepath)
	print("removing error: ", delthing)
	var err = ResourceSaver.save(filepath, packed, ResourceSaver.FLAG_COMPRESS)
	print("this error? ", err, " and ", packerr)
	pass

func get_pretty_png():
	var imgdata: Image = render.texture.get_data()
	imgdata.flip_y()
	var newsize = get_export_pixel_size()
	imgdata.resize(newsize,newsize, Image.INTERPOLATE_NEAREST)
	var buf = imgdata.save_png_to_buffer()
	return buf

func export_image(filepath):
	var imgdata = render.texture.get_data()
	#imgdata.flip_y()
	imgdata.save_png(filepath)
	pass

func export_normal(filepath):
	var imgdata = normal_render.texture.get_data()
	#imgdata.flip_y()
	var newsize = get_export_pixel_size()
	imgdata.resize(newsize,newsize, Image.INTERPOLATE_NEAREST)
	print("normals are ", imgdata)
	imgdata.save_png(filepath)
	pass
	
func get_raw_png():
	var imgdata: Image = pre_color_and_shadow.texture.get_data()
	var newsize = get_export_pixel_size()
	imgdata.resize(newsize,newsize, Image.INTERPOLATE_NEAREST)
	return imgdata.save_png_to_buffer()
	
func export_raw_image(filepath):
	var imgdata = pre_color_and_shadow.texture.get_data()
	var newsize = get_export_pixel_size()
	imgdata.resize(newsize,newsize, Image.INTERPOLATE_NEAREST)
	imgdata.save_png(filepath)
	
func get_export_pixel_size():
	var export_size = active_piece.export_size
	if export_size == false or export_size == null:
		export_size = 0
	return pow(2, 11-export_size)

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
	self.rename_selected_layer(new_name)
	pass # Replace with function body.


func _on_UI_save_file(filepath):
	self.save_current(filepath)
	pass # Replace with function body.


func _on_UI_load_file(filepath):
	self.load_thing(filepath)
	pass # Replace with function body.


func _on_UI_undo_cut():
	undo_cut()
	pass # Replace with function body.


func _on_UI_redo_cut():
	redo_cut()
	pass # Replace with function body.


func _on_UI_export_to_file(filepath: String):
	if filepath.ends_with(".raw.png"):
		export_raw_image(filepath)
	elif filepath.ends_with(".png"):
		export_image(filepath)
	pass # Replace with function body.


func _on_UI_append_file(filepath):
	self.load_thing(filepath, true)
	pass # Replace with function body.

func _on_active_piece_change():
	palette_material.set_shader_param("shadow_amount", active_piece.shadow_size)
	palette_material.set_shader_param("shadow_passes", active_piece.shadow_passes)
	pass


func _on_UI_new_canvas():
	pass # Replace with function body.
