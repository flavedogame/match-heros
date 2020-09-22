extends Node2D

onready var local_map:LocalMap = get_parent()
export var stats: Resource
onready var buttons_container = $VBoxContainer

var button_scene = preload("res://Scenes/map/MapNodeDetailButton.tscn")

func _ready():
	var buttons = stats.buttons
	var name = stats.name
	var folder_name = stats.map_node_id
	for button_name in buttons:
		#if button is visible
		var button_instance = button_scene.instance()
		var button_stats = load("res://resources/mapNode/"+folder_name+"/"+button_name+".tres").duplicate()
		button_instance.init(button_stats,local_map)
		buttons_container.add_child(button_instance)
		

