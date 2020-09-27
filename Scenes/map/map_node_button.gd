extends Button

var stat:MapNodeStats
onready var label:Label = $Label

func _ready():
	rect_position = stat.position
	label.text = stat.name

func init(_stat):
	stat = _stat
