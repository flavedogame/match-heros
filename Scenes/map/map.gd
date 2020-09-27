extends Node2D

class_name LocalMap

var map:FullMapStats
var map_node_button = preload("res://Scenes/map/map_node_button.tscn")
onready var lines = $lines
onready var buttons = $buttons

func _ready():
	map = load("res://resources/mapNode/start_map.tres")
	var map_node_id_to_instance = {}
	for map_node in map.map_nodes:
		#check visibility
		var map_node_stat = load("res://resources/mapNode/"+map.map_nodes[map_node]+".tres")
		var map_node_button_instance = map_node_button.instance()
		map_node_button_instance.init(map_node_stat)
		buttons.add_child(map_node_button_instance)
		map_node_id_to_instance[map_node] = map_node_button_instance
		
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
		
		

