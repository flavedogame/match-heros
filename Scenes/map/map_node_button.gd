extends Button

class_name MapNodeButton

var stat:MapNodeStats
onready var label:Label = $Label

var center_position
var topright_position


func _ready():
	set_position(topright_position)
	#rect_position = stat.position
	label.text = stat.name
	self.connect("pressed",self,"button_pressed")

func button_pressed():
	Events.emit_signal("select_map_node_button",self)

func init(_stat,min_xy):
	stat = _stat
	center_position = stat.position-min_xy
	topright_position = center_position - rect_pivot_offset
