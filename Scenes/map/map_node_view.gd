extends ColorRect

onready var local_map = get_parent()

onready var buttons_container = $VBoxContainer

var button_scene = preload("res://Scenes/map/MapNodeDetailButton.tscn")
var node_button:MapNodeButton

func init(button:MapNodeButton):
	node_button = button
	#rect_size = GlobalValues.control_size
	#rect_position = GlobalValues.control_position

func clear_buttons():
	Utils.clear_all_children(buttons_container)

func update_buttons():
	clear_buttons()
	var stats: Resource = node_button.stat
	var buttons = stats.buttons
	var name = stats.name
	var folder_name = stats.map_node_id
	for button_name in buttons:
		#if button is visible
		var button_instance = button_scene.instance()
		var button_stats = load("res://resources/mapNode/"+folder_name+"/"+button_name+".tres").duplicate()
		if is_button_visible(button_stats):
			button_instance.init(button_stats)
			buttons_container.add_child(button_instance)
	#cancel button
	var button_instance = button_scene.instance()
	button_instance.init(null)
	buttons_container.add_child(button_instance)

func is_button_visible(button_stats):
	if button_stats.visible_condition.size() == 0:
		return true
	for condition_combination in button_stats.visible_condition:
		if Achievements.is_achievement_finished(condition_combination):
			return true
	return false
	


func _ready():
	update_buttons()
	Events.connect("achievement_update",self,"update_buttons")
		


