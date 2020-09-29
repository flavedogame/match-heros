extends Control

var map:FullMapStats
var map_node_button = preload("res://Scenes/map/map_node_button.tscn")
onready var lines = $lines
onready var buttons = $buttons
var extended_size =  Vector2(500,500)
#extents, start offset
func _ready():
	map = load("res://resources/mapNode/start_map.tres")
	var map_node_id_to_instance = {}
	var extents:Extents = Extents.new(extended_size)
	
	for map_node in map.map_nodes:
		#check visibility
		var map_node_stat = load("res://resources/mapNode/"+map.map_nodes[map_node]+".tres")
		extents.add_point(map_node_stat.position)
		
	var min_xy = extents.min_xy()
	
	for map_node in map.map_nodes:
		#check visibility
		var map_node_stat = load("res://resources/mapNode/"+map.map_nodes[map_node]+".tres")
		var map_node_button_instance = map_node_button.instance()
		map_node_button_instance.init(map_node_stat,min_xy)
		buttons.add_child(map_node_button_instance)
		map_node_id_to_instance[map_node] = map_node_button_instance
		#extents.add_point(map_node_button_instance.center_position)
		
	for connection in map.connections:
		#check visibility
		var line = Line2D.new()
		var button0 = map_node_id_to_instance[connection[0]]
		var button1 = map_node_id_to_instance[connection[1]]
		
		var position0 = button0.center_position
		var position1 = button1.center_position
		print(position0,position1)
		line.add_point(position0)
		line.add_point(position1)
		lines.add_child(line)
		
	rect_min_size = extents.xy_size()
	
	#some bugs here
	#if no previous position
#	var content_size = rect_min_size
#	print(rect_min_size)
#	var center = content_size/2
#	get_parent(). rect_size = get_parent().full_size
#	var half_size = rect_size/2
#	print(center.x - half_size.x," ",center.y - half_size.y)
#	get_parent().scroll_horizontal = center.x - half_size.x
#	get_parent().scroll_vertical = center.y - half_size.y
#	print(get_parent().scroll_horizontal ," ",get_parent().scroll_vertical)
