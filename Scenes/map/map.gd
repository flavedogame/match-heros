extends ColorRect

class_name MapView

onready var control_view = $control_view
onready var control_bottom_view = $control_bottom_view

var map_load_view = preload("res://Scenes/map/map_node_view.tscn")
var dialog_view = preload("res://DialogueSystem/Scene/DialogueView.tscn")

func _ready():
	Events.connect("select_map_node_button",self,"load_map_node_view")
	Events.connect("cancel_select_map_node_button",self,"unload_map_node_view")
	Events.connect("start_dialog",self,"start_dialog")
	Events.connect("finish_dialog",self,"finish_dialog")
	control_view.margin_top = GlobalValues.stage_height
	control_view.margin_bottom = -GlobalValues.bottom_height
	control_bottom_view.margin_top = GlobalValues.stage_height
	control_bottom_view.margin_bottom = 0
	
func start_dialog(dialog_id, dialog_path):
	var dialog_view_instance = dialog_view.instance()
	dialog_view_instance.init(dialog_id, dialog_path)
	control_bottom_view.add_child(dialog_view_instance)
	
func finish_dialog(dialog_id):
	pass#Utils.clear_all_children(map_node_view_position)

func load_map_node_view(button:MapNodeButton):
	var map_load_view_instance = map_load_view.instance()
	map_load_view_instance.init(button)
	control_view.add_child(map_load_view_instance)
	
func unload_map_node_view():
	Utils.clear_all_children(control_view)

