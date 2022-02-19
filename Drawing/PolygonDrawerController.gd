extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float, 0.0, 1.0) var polygon_lightness = 0.0 setget set_polygon_lightness

onready var drag_pen = $DragPen
onready var display_line: Line2D = $DisplayLine
onready var tween = $Tween

var drawing = false
var current_polygon: Polygon2D
var last_point = Vector2.ZERO
var last_mouse_pos = Vector2.ZERO

var cut_move_frac = 0.5

signal create_polygon(polygon)
signal move_cuts(delta)

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_polygon()
	pass # Replace with function body.

func set_drag_leash_size(_new_size):
	drag_pen.max_leash = _new_size

func reset_polygon():
	display_line.set_as_toplevel(true)
	current_polygon = Polygon2D.new()
	current_polygon.color = Color(polygon_lightness, polygon_lightness, polygon_lightness, 1)
	display_line.points = PoolVector2Array()
	#self.add_child(current_polygon)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_polygon_lightness(_pl):
	polygon_lightness = _pl
	current_polygon.color = Color(polygon_lightness, polygon_lightness, polygon_lightness, 1)

func _process(delta):

	if drawing:
		var penpos: Vector2 = drag_pen.get_pen_pos()
		var length_away = penpos.distance_to(last_point)
		if length_away > 4:
			last_point = penpos
			print("drawing at ", penpos)
			var poly = current_polygon.polygon
			poly.append(penpos)
			current_polygon.polygon = poly
			display_line.points = poly
			print(current_polygon.polygon.size())
		pass

func _unhandled_input(event):
	# Mouse in viewport coordinates.
	if event is InputEventAction:
		if event.action == "draw":
			print("Mouse Click/Unclick at: ", drag_pen.get_pen_pos())
		if event.action == "zoom_in":
			print("zooming in")
			self.zoom += Vector2(0.1,0.1)
		if event.action == "zoom_out":
			print("zooming out")
			self.zoom -= Vector2(0.1,0.1)
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("draw"):
			print("draw pressed")
			drawing = true
		if Input.is_action_just_released("draw"):
			print("draw depressed")
			drawing = false
			#self.get_parent().add_child(current_polygon)
			emit_signal("create_polygon", current_polygon)
			print(current_polygon)
			reset_polygon()
		if event.is_pressed():
		# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				self.zoom += Vector2(0.1, 0.1)
				print(self.zoom)
				pass
			# call the zoom function
		# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				self.zoom -= Vector2(0.1, 0.1)
				print(self.zoom)
				pass
			# call the zoom function
	elif event is InputEventMouseMotion:
		var mousepos = get_global_mouse_position()
		drag_pen.global_position = mousepos
		if Input.is_action_pressed("pan"):
			tween.interpolate_property(self, "global_position",
			self.global_position, self.global_position+((last_mouse_pos-mousepos) * Vector2(2.0, 2.0)), 0.05,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		elif Input.is_action_pressed("movecuts"):
			emit_signal("move_cuts", (mousepos-last_mouse_pos)*cut_move_frac)
			pass

			#self.global_position += (last_mouse_pos - mousepos)
		last_mouse_pos = mousepos
		
		


func _on_UI_resize_pen_leash(new_size):
	set_drag_leash_size(new_size)
	pass # Replace with function body.


func _on_UI_set_cut_move_frac(new_frac):
	cut_move_frac=new_frac
	pass # Replace with function body.
