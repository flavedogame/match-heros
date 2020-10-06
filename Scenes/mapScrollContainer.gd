extends DraggableScrollContainer

func _ready():
	Events.connect("select_map_node_button",self,"focus_on")
	Events.connect("cancel_select_map_node_button",self,"focus_off")
	

func focus_on(button:MapNodeButton):
	is_swipeable = false
	var position = button.center_position
	#rect_size = focus_size
	margin_bottom = - GlobalValues.bottom_height - GlobalValues.control_height
	yield(get_tree(), 'idle_frame')
	var half_size = rect_size/2
	scroll_horizontal = position.x - half_size.x
	scroll_vertical = position.y - half_size.y

func focus_off():
	is_swipeable = true
	margin_bottom = -GlobalValues.bottom_height
	yield(get_tree(), 'idle_frame')
	#if dont want node jump to center, comment everything except rect_size = full_size
	var half_size = rect_size/2
	var position = Vector2(scroll_horizontal+ half_size.x,scroll_vertical+half_size.y)
	
	#rect_size = full_size
	half_size = rect_size/2
	scroll_horizontal = position.x - half_size.x
	scroll_vertical = position.y - half_size.y
