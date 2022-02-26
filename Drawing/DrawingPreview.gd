extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PoolColorArray) var color = PoolColorArray([Color(1, 0, 0, 0.5)])
export(bool) var auto_smoothing_on = true
export(float) var smooth_amount = 10.0
var raw_line = PoolVector2Array()
var path: PoolVector2Array setget ,get_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func add_point(point: Vector2):
	curve.add_point(point)
	#raw_line.append(point)
	#self.smooth()
	print(path)
	self.update()
	pass

func clear():
	raw_line = PoolVector2Array()
	curve.clear_points()

func _smooth():
	return
	var point_count = raw_line.size()-1
	curve.clear_points()
	for i in point_count:
		var point = raw_line[i]
		var spline = _get_spline(i)
		#if point != null or spline != null:
		curve.add_point(point, -spline, spline)

func smooth():
	return
	for point in raw_line:
		print("point ", point)
		curve.add_point(point, Vector2.ZERO, Vector2.ZERO)

func _get_spline(i):
	var last_point = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	if last_point == null or next_point == null:
		return 0
	var spline = last_point.direction_to(next_point) * smooth_amount
	return spline
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _get_point(i) -> Vector2:
	if raw_line.size() == 0:
		return Vector2.ZERO
	elif i < 0:
		return raw_line[raw_line.size()-1]
	elif raw_line.size()-1 < i:
		return raw_line[0]
	else:
		return raw_line[i]
	pass

func get_path():
	return curve.get_baked_points()

func _draw():
	draw_rect(get_viewport_rect(), Color.transparent)
	print("drawing?")
	var newline = PoolVector2Array()
	for point in path:
		newline.append(point - self.global_position)
	draw_polygon(newline, self.color)
	draw_polyline(newline, self.color[0])
