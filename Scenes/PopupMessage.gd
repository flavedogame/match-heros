extends ColorRect

onready var label = $RichTextLabel

func show_popup_message(message):
	visible = true
	label.bbcode_text = message

func _ready():
	Events.connect("show_popup_message",self,"show_popup_message")


func _on_Button_pressed():
	visible = false
