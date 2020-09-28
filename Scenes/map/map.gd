extends Node2D

class_name MapView

var map_load_view = preload("res://Scenes/map/map_node_view.tscn")

func _ready():
	Events.connect("select_map_node_button",self,"load_map_node_view")

func load_map_node_view(button):
	var map_load_view_instance = map_load_view.instance()
	$map_node_view_position.add_child(map_load_view_instance)

