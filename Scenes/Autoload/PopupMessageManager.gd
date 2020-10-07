extends Node

var PopupMessage = preload("res://Scenes/UI/PopupMessage.tscn")

func show_popup_message(message):
	var root = get_tree().get_root()
	var popupMessageInstance = PopupMessage.instance()
	popupMessageInstance.init(message)
	root.add_child(popupMessageInstance)

func _ready():
	Events.connect("show_popup_message",self,"show_popup_message")
