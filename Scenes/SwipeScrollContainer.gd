extends ScrollContainer

class_name DraggableScrollContainer

# Allows you to scroll a scroll container by dragging.
# Includes momentum.

var swiping = false
var swipe_start
var swipe_mouse_start
var swipe_mouse_times = []
var swipe_mouse_positions = []
var is_swipeable = true

var full_size = Vector2(573,966)
var focus_size = Vector2(573,300)

var click_time = 0.5 * 1000#seconds to milliseconds
var click_distance = 10

func click(ev):
	pass
	
func is_click(ev):
	if not swipe_mouse_start:
		return false
	var current_time = OS.get_ticks_msec()
	var current_position = ev.position
	var distance = current_position.distance_to(swipe_mouse_start)
	print(distance)
	return current_time - swipe_mouse_times[0] <= click_time and distance<click_distance
	

func _input(ev):
	if not is_swipeable:
		return 
	if ev is InputEventMouseButton:
		if ev.pressed:
			swiping = true
			swipe_start = Vector2(get_h_scroll(), get_v_scroll())
			swipe_mouse_start = ev.position
			swipe_mouse_times = [OS.get_ticks_msec()]
			swipe_mouse_positions = [swipe_mouse_start]
		else:
			if is_click(ev):
				click(ev)
			else:
				swipe_mouse_times.append(OS.get_ticks_msec())
				swipe_mouse_positions.append(ev.position)
				var source = Vector2(get_h_scroll(), get_v_scroll())
				var idx = swipe_mouse_times.size() - 1
				var now = OS.get_ticks_msec()
				var cutoff = now - 100
				for i in range(swipe_mouse_times.size() - 1, -1, -1):
					if swipe_mouse_times[i] >= cutoff: idx = i
					else: break
				var flick_start = swipe_mouse_positions[idx]
				var flick_dur = min(0.3, (ev.position - flick_start).length() / 1000)
				if flick_dur > 0.0:
					var tween = Tween.new()
					add_child(tween)
					var delta = ev.position - flick_start
					var target = source - delta * flick_dur * 15.0
					tween.interpolate_method(self, 'set_h_scroll', source.x, target.x, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
					tween.interpolate_method(self, 'set_v_scroll', source.y, target.y, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
					tween.interpolate_callback(tween, flick_dur, 'queue_free')
					tween.start()
			swiping = false
	elif swiping and ev is InputEventMouseMotion:
		var delta = ev.position - swipe_mouse_start
		set_h_scroll(swipe_start.x - delta.x)
		set_v_scroll(swipe_start.y - delta.y)
		swipe_mouse_times.append(OS.get_ticks_msec())
		swipe_mouse_positions.append(ev.position)
