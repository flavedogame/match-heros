
class_name Extents

var min_x
var min_y
var max_x
var max_y
var has_point = false
var extended_size

func _init(_extended_size):
	extended_size = _extended_size
	
func add_point(point:Vector2):
	if has_point:
		min_x = min(min_x, point.x)
		min_y = min(min_y, point.y)
		max_x = max(max_x, point.x)
		max_y = max(max_y, point.y)
	else:
		min_x = point.x
		max_x = point.x
		min_y = point.y
		max_y = point.y
		has_point = true

func min_xy():
	return Vector2(min_x,min_y) - extended_size
	
func max_xy():
	return Vector2(max_x,max_y) + extended_size

func xy_size():
	return max_xy() - min_xy() + extended_size*2
	
