extends Button

var stats: MapDetailButtonStats
onready var label = $Label

func _ready():
	if stats:
		label.text = stats.name
	else:
		label.text = "Cancel"
	self.connect("pressed", self, "_on_Button_pressed")
	
func _on_Button_pressed():
	if stats == null:
		Events.emit_signal("cancel_select_map_node_button")
		return
	for action in stats.actions:
		for action_key in action:
			if action_key == "battle_action":
				var action_content = action[action_key] 
				Events.emit_signal("encounter_battle",stats.battle_id,action_content)

func init(button_stats):
	stats = button_stats
