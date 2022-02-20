extends Resource

class_name PaletteCollection
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array, Texture) var palettes
export(Texture) var active setget set_active
export(float, 0, 1) var selected = 0.0
var imgdata: Image = Image.new()
export(Array, Texture) var built_in_palettes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_palettes()
	pass # Replace with function body.

func clear_palettes():
	palettes = []
	for palette in built_in_palettes:
		palettes.append(palette)
	self.emit_changed()

func set_active(_sel: Texture):
	if _sel in palettes:
		active = _sel
		imgdata = _sel.get_data()
		emit_changed()

func get_selected_color():
	var pix = imgdata.get_pixel(0.5, imgdata.get_width() * selected)
	if pix != null:
		return pix 
	else:
		return Color(1, 1, 1, 1)

func on_custom_palette_change():
	var cust = load("user://custom_palettes.tres")
	for img in cust.images:
		var tx = ImageTexture.new()
		tx.create_from_image(img)
		palettes.append(tx)
	self.emit_changed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
