extends Button

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
	Events.emit_signal("select_map_node_button",stat)

func init(_stat):
	stat = _stat
	center_position = stat.position
	topright_position = stat.position - rect_pivot_offset
	print(topright_position)
