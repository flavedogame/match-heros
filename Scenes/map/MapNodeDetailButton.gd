extends Button

var stats: MapDetailButtonStats
var local_map: LocalMap
onready var label = $Label

func _ready():
	label.text = stats.name
	self.connect("pressed", self, "_on_Button_pressed")
	
func _on_Button_pressed():
	for action in stats.actions:
		for action_key in action:
			if action_key == "battle_action":
				var action_content = action[action_key] 
				Events.emit_signal("encounter_battle",stats.battle_id,action_content)

func init(button_stats,map):
	stats = button_stats
	local_map = map
