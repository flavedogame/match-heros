extends Node2D

class_name LocalMap

var map:FullMap
var map_node_button = preload("res://Scenes/map/map_node_button.tscn")

func _ready():
	map = load("res://resources/mapNode/start_map.tres")
	
	for map_node in map.map_nodes:
		#check visibility
		var map_node_stat = load("res://resources/mapNode/"+map.map_nodes[map_node]+".tres")
		var map_node_button_instance = map_node_button.instance()
		map_node_button_instance.init(map_node_stat)
		add_child(map_node_button_instance)

