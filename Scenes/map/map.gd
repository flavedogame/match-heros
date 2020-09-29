extends Node2D

class_name MapView

onready var map_node_view_position = $map_node_view_position

var map_load_view = preload("res://Scenes/map/map_node_view.tscn")

func _ready():
	Events.connect("select_map_node_button",self,"load_map_node_view")
	Events.connect("cancel_select_map_node_button",self,"unload_map_node_view")
	

func load_map_node_view(button:MapNodeButton):
	var map_load_view_instance = map_load_view.instance()
	map_load_view_instance.init(button)
	map_node_view_position.add_child(map_load_view_instance)
	
func unload_map_node_view():
	Utils.clear_all_children(map_node_view_position)

