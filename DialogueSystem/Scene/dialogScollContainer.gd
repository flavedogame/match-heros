extends DraggableScrollContainer

onready var scrollbar = get_v_scrollbar()
var flick_dur = 0.1
signal click_scrollbar

func click(ev):
	emit_signal("click_scrollbar")

func scroll_to(target):
	var start = scroll_vertical
	if start == target:
		#scroll_vertical = target
		return
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_method(self, 'set_v_scroll', start, target, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_callback(tween, flick_dur, 'queue_free')
	tween.start()
