extends Resource

class_name PaletteCollection
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array, Texture) var palettes
export(Texture) var active setget set_active
export(float, 0, 1) var selected = 0.0
var imgdata: Image = Image.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
