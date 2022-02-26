extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name DrawingPreview

export(float) var smoothing_amount = 0
export(PoolColorArray) var preview_fill_colors
export(Color) var preview_line_color
export(float) var preview_line_width = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_point(point: Vector2):
	point -= self.global_position
	curve.add_point(point, Vector2.ZERO, Vector2.ZERO)
	if curve.get_point_count() > 4:
		self.smooth()
	self.update()

func clear():
	curve.clear_points()
	self.update()

func get_poly(color = Color(1,1,1,1)):
	var poly = Polygon2D.new()
	poly.color = color
	poly.polygon = self.curve.get_baked_points()
	poly.global_position = self.global_position
	return poly

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	var pnts = curve.get_baked_points()
	draw_polygon(pnts, preview_fill_colors)
	draw_polyline(pnts, preview_line_color, preview_line_width)
	
	
func straighten(value):
	if not value: return
	for i in curve.get_point_count():
		curve.set_point_in(i, Vector2())
		curve.set_point_out(i, Vector2())

func smooth():

	var point_count = curve.get_point_count()
	for i in point_count:
		var spline = _get_spline(i)
		curve.set_point_in(i, -spline)
		curve.set_point_out(i, spline)

func _get_spline(i):
	var last_point = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	var spline = last_point.direction_to(next_point) * smoothing_amount
	return spline

func _get_point(i):
	var point_count = curve.get_point_count()
	i = wrapi(i, 0, point_count - 1)
	return curve.get_point_position(i)
