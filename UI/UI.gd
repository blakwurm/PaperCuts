extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



signal new_canvas
signal add_mode_changed(new_add)
signal layer_selected(layer_name)
signal layer_height_raised(layer_name, new_height)
signal add_layer(filled)
signal del_selected_layer()
signal dupe_selected_layer()
signal rename_selected_layer(new_name)
signal resize_pen_leash(new_size)
signal resize_drag_period(new_value)
signal set_curve_percent(new_percent)
signal set_cut_move_frac(new_frac)
signal set_mirror_mode(mirror_mode)
signal save_file(filepath)
signal load_file(filepath)
signal append_file(filepath)
signal export_to_file(filepath)
signal set_zoom(new_zoom_amt)
signal undo_cut
signal redo_cut

onready var layer_list = $Panel/VBoxContainer/LayerList
onready var color_menu_box = $ItemList/ColorMenuBox

var opened_path = null

const view_material = preload("res://PaperCuts/palette_render_material.tres")
const active_piece = preload("res://Resources/ActivePiece.tres")
const palette_collection = preload("res://Resources/palette_collection.tres")

const palette_dir_path = "user://palettes"

var custom_palettes: CustomPalettes

# Called when the node enters the scene tree for the first time.
func _ready():
	active_piece.connect("changed", self, "_on_active_piece_change")
	pass # Replace with function body.
	get_tree().connect("files_dropped", self, "_on_files_dropped")
	load_user_palettes()

func load_user_palettes():
	var dir = Directory.new()
	palette_collection.clear_palettes()
	if !dir.dir_exists(palette_dir_path):
		dir.make_dir(palette_dir_path)
	if dir.open(palette_dir_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("filename: ", file_name)
			if file_name.ends_with(".png"):
				var newpath = palette_dir_path + "/" + file_name
				var img = Image.new()
				img.load(newpath)
				var tx = ImageTexture.new()
				tx.create_from_image(img, 0)
				palette_collection.palettes.append(tx)
				palette_collection.emit_changed()
			file_name = dir.get_next()
		pass
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("save"):
		if active_piece.from_saved:
			emit_signal("save_file", $SaveDialog.current_path)
		else:
			$Panel/VBoxContainer/HBoxContainer8/SaveButton.emit_signal("pressed")
	elif Input.is_action_just_pressed("save_as"):
		$Panel/VBoxContainer/HBoxContainer8/SaveButton.emit_signal("pressed")
	elif Input.is_action_just_pressed("open"):
		$Panel/VBoxContainer/HBoxContainer8/OpenButton.emit_signal("pressed")
	elif Input.is_action_just_pressed("export"):
		$Panel/VBoxContainer/HBoxContainer8/ExportButton.emit_signal("pressed")
	elif Input.is_action_just_pressed("undo_cut"):
		$Panel/VBoxContainer/HBoxContainer12/UndoButton.emit_signal("pressed")
	elif Input.is_action_just_pressed("redo_cut"):
		$Panel/VBoxContainer/HBoxContainer12/RedoButton.emit_signal("pressed")
	elif Input.is_action_just_pressed("toggle_clipper_add"):
		var a = $Panel/VBoxContainer/HBoxContainer5/ClipperAddToggle
		a.pressed = !a.pressed
		a.emit_signal("toggled", a.pressed)

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
	emit_signal("layer_selected", layer_name)
	layer_list.select_item_key(layer_name)
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


func _on_SaveButton_pressed():
	$SaveDialog.show()
	pass # Replace with function body.


func _on_OpenButton_pressed():
	$LoadDialog.show()
	pass # Replace with function body.


func _on_ExportButton_pressed():
	$ExportDialog.show()
	pass # Replace with function body.


func _on_NewButton_pressed():
	#emit_signal("new_canvas")
	$ConfirmationDialog.show()
	pass # Replace with function body.


func _on_RedoButton_pressed():
	emit_signal("redo_cut")
	pass # Replace with function body.


func _on_UndoButton_pressed():
	emit_signal("undo_cut")
	pass # Replace with function body.


func _on_SaveDialog_file_selected(path):
	emit_signal("save_file", path)
	pass # Replace with function body.


func _on_LoadDialog_file_selected(path):
	opened_path = path
	emit_signal("load_file", path)
	var savedia:FileDialog = $SaveDialog
	var loaddia:FileDialog = $LoadDialog
	savedia.current_dir = loaddia.current_dir
	savedia.current_file = loaddia.current_file
	savedia.current_path = loaddia.current_path
	pass # Replace with function body.


func _on_ExportDialog_file_selected(path):
	print(path)
	emit_signal("export_to_file", path)
	pass # Replace with function body.


func _on_RenameDialog_confirmed():
	var new_text = $RenameDialog/RenameBox.text
	emit_signal("rename_selected_layer", new_text)
	pass # Replace with function body.


func _on_RenameLayerButton_pressed():
	$RenameDialog.show()
	$RenameDialog/RenameBox.grab_focus()
	pass # Replace with function body.


func _on_UI_layer_selected(layer_name):
	$Panel/VBoxContainer/RenameLayerButton.text = "Rename '%s'" % layer_name
	pass # Replace with function body.


func _on_RenameBox_text_entered(new_text):
	emit_signal("rename_selected_layer", new_text)
	$RenameDialog/RenameBox.text = ""
	$RenameDialog.visible = false
	pass # Replace with function body.

func _name_change(new_text):
	active_piece.name = new_text
	active_piece.emit_changed()
	
func _on_NameField_text_entered(new_text):
	_name_change(new_text)
	pass # Replace with function body.


func _on_NameField_focus_exited():
	_name_change($Panel/VBoxContainer/HBoxContainer/NameField.text)
	pass # Replace with function body.

func _artist_change(new_text):
	active_piece.artist = new_text
	active_piece.emit_changed()

func _on_ArtistField_text_entered(new_text):
	_artist_change( new_text)
	pass # Replace with function body.


func _on_ArtistField_focus_exited():
	_artist_change($Panel/VBoxContainer/HBoxContainer2/ArtistField.text)
	pass # Replace with function body.

func _version_change(new_ver):
	active_piece.version = new_ver
	active_piece.emit_changed()

func _on_VersionSpinner_value_changed(value):
	_version_change(value)
	pass # Replace with function body.


func _on_VersionSpinner_focus_exited():
	_version_change($Panel/VBoxContainer/HBoxContainer4/VersionSpinner.value)
	pass # Replace with function body.

func _on_active_piece_change():
	$Panel/VBoxContainer/HBoxContainer/NameField.text = active_piece.name
	$Panel/VBoxContainer/HBoxContainer2/ArtistField.text = active_piece.artist
	$Panel/VBoxContainer/HBoxContainer4/VersionSpinner.value = active_piece.version
	$Panel/VBoxContainer/HBoxContainer15/ShadowSizeSlider.value = active_piece.shadow_size
	$Panel/VBoxContainer/HBoxContainer15/ShadowSizeSpinner.value = active_piece.shadow_size
	$Panel/VBoxContainer/HBoxContainer16/ShadowPassesSlider.value = active_piece.shadow_passes
	$Panel/VBoxContainer/HBoxContainer16/ShadowPassesSpinner.value = active_piece.shadow_passes
	$Panel/VBoxContainer/HBoxContainer3/savescenecheck.pressed = active_piece.save_with_scene
	$Panel/VBoxContainer/HBoxContainer3/saveprettycheck.pressed = active_piece.save_with_pretty
	$Panel/VBoxContainer/HBoxContainer3/saverawcheck.pressed = active_piece.save_with_raw
	$Panel/VBoxContainer/HBoxContainer18/ExportResSelector.selected = active_piece.export_size
	

func _on_files_dropped(files, screen):
	var firstfile: String = files[0]
	if firstfile.ends_with("papercut.tres"):
		#emit_signal("load_file", firstfile)
		$LoadDialog.current_path = firstfile
		$LoadDialog.show()
	print(files)


func _on_OpenPalettesButton_pressed():
	var paldir = "file://" + OS.get_user_data_dir() + "/" + "palettes"
	OS.shell_open(paldir)
	pass # Replace with function body.


func _on_ReloadPalettesButton_pressed():
	self.load_user_palettes()
	pass # Replace with function body.


func _on_AppendButton_pressed():
	$AppendDialog.show()
	pass # Replace with function body.


func _on_AppendDialog_file_selected(path):
	emit_signal("append_file", path)
	pass # Replace with function body.


func _on_ZoomSpinner_value_changed(value):
	$Panel/VBoxContainer/HBoxContainer13/ZoomSlider.value = value
	emit_signal("set_zoom", value)
	pass # Replace with function body.


func _on_ZoomSlider_value_changed(value):
	$Panel/VBoxContainer/HBoxContainer13/ZoomSpinner.value = value
	emit_signal("set_zoom", value)
	pass # Replace with function body.


func _on_PolygonDrawingCamera_change_zoom(zoomdist):
	$Panel/VBoxContainer/HBoxContainer13/ZoomSlider.value = zoomdist
	$Panel/VBoxContainer/HBoxContainer13/ZoomSpinner.value = zoomdist
	pass # Replace with function body.


func _on_ShadowSize_value_changed(value):
	active_piece.shadow_size = value
	active_piece.emit_changed()
	pass # Replace with function body.


func _on_ShadowPasses_value_changed(value):
	active_piece.shadow_passes = value
	active_piece.emit_changed()
	pass # Replace with function body.


func _on_Canvas_layer_removed(layer_name):
	layer_list.remove_item(layer_name)
	pass # Replace with function body.



func _on_saveshadercheck_toggled(button_pressed):
	active_piece.save_with_shader = button_pressed
	active_piece.emit_changed()
	pass # Replace with function body.


func _on_saverawcheck_toggled(button_pressed):
	active_piece.save_with_raw = button_pressed
	active_piece.emit_changed()
	pass # Replace with function body.


func _on_saveprettycheck_toggled(button_pressed):
	active_piece.save_with_pretty = button_pressed
	active_piece.emit_changed()
	pass # Replace with function body.


func _on_MirrorLRCheck_toggled(button_pressed):
	pass # Replace with function body.


func _on_MirrorTBCheck_toggled(button_pressed):
	pass # Replace with function body.



func _on_MirrorOption_item_selected(index):
	emit_signal("set_mirror_mode", index)
	pass # Replace with function body.


func _on_ConfirmationDialog_confirmed():
	active_piece.from_saved = false
	active_piece.name = ""
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_Period_value_changed(value):
	emit_signal("resize_drag_period", value)
	$Panel/VBoxContainer/HBoxContainer9/PeriodSlider.value = value
	$Panel/VBoxContainer/HBoxContainer9/PeriodSpinner.value = value
	pass # Replace with function body.


func _on_Curve_value_changed(value):
	emit_signal("set_curve_percent", value)
	$Panel/VBoxContainer/HBoxContainer17/CurveSlider.value = value
	$Panel/VBoxContainer/HBoxContainer17/CurveSpinner.value = value
	pass # Replace with function body.

func _on_savescenecheck_toggled(button_pressed):
	active_piece.save_with_scene = true
	active_piece.emit_changed()
	pass

func ___on_savescenecheck_toggled(button_pressed):
	if active_piece.from_saved:
		$SaveSceneDialog.current_dir = $SaveDialog.current_dir
		$SaveSceneDialog.show()
	else:
		$Panel/VBoxContainer/HBoxContainer3/savescenecheck.pressed = false
	pass # Replace with function body.


func _on_SaveSceneDialog_dir_selected(dir):
	var open_path = $SaveDialog.current_dir
	active_piece.save_with_scene = true
	var rel = get_rel_path(open_path, dir)
	active_piece.export_scene_path = rel
	pass # Replace with function body.


func _on_SaveSceneDialog_popup_hide():
	$Panel/VBoxContainer/HBoxContainer3/savescenecheck.pressed = false
	pass # Replace with function body.

func get_rel_path(basepath: String, divpath: String):
	if basepath.ends_with("/"):
		basepath = basepath.substr(0, basepath.length()-1)
	if divpath.ends_with("/"):
		divpath = divpath.substr(0, divpath.length()-1)
	print(basepath)
	var basesplit: PoolStringArray = basepath.split("/")
	var divsplit: PoolStringArray = divpath.split("/")
	var back_count = 0
	var common_count = 0
	for ind in range(basesplit.size()):
		var n = basesplit[ind]
		if back_count == 0:
			var m = divsplit[ind]
			if n == m:
				common_count += 1
			else:
				back_count += 1
		else: 
			back_count += 1
	var retcont = PoolStringArray()
	for i in range(back_count):
		retcont.append("..")
	for i in range(common_count):
		divsplit.remove(0)
	retcont.append_array(divsplit)
	var ret = retcont.join("/")
	return ret


func _on_ExportResSelector_item_selected(index):
	active_piece.export_size = index
	active_piece.emit_changed()
	pass # Replace with function body.
