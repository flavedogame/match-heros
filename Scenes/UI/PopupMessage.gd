extends CanvasLayer

onready var label = $ColorRect/RichTextLabel
var message

func init(_message):
	message = _message
	
func _ready():
	show_popup_message()

func show_popup_message():
	label.bbcode_text = message


func _on_Button_pressed():
	queue_free()
