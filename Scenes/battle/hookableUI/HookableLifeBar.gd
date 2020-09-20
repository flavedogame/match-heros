extends Control
class_name LifeBar

onready var bar = $TextureProgress
onready var label = $LifeLabel

var max_value: int = 0 setget set_max_value
var value: int = 0 setget set_value

export var LABEL_ABOVE: bool
export var HIDE_ON_DEPLETED: bool = true


func _ready() -> void:
	if LABEL_ABOVE:
		label.raise()

func displayLabel(label, value, new_value):
	label.text = "%s/%s" % [value, max_value]

func set_max_value(new_value) -> void:
	max_value = new_value
	bar.max_value = new_value
	displayLabel(label, value, new_value)


func set_value(new_value) -> void:
	print("set_value")
	value = new_value
	bar.value = new_value
	displayLabel(label,new_value, max_value)


func initialize(battler: Battler) -> void:
	_connect_value_signals(battler)

func _on_value_changed(new_value, old_value) -> void:
	self.value = new_value


func _on_value_depleted() -> void:
	print("_on_value_depleted")
	if HIDE_ON_DEPLETED:
		hide()
		
func _connect_value_signals(battler: Battler) -> void:
	var battler_stats = battler.stats
	battler_stats.connect("health_changed", self, "_on_value_changed")
	battler_stats.connect("health_depleted", self, "_on_value_depleted")

	self.max_value = battler_stats.max_health
	self.value = battler_stats.health
