extends Control

onready var spin_box: SpinBox = $Column/HBoxContainer/SpinBox


func _ready():
	GameSaver.load_globally()

func _on_SaveButton_pressed() -> void:
	GameSaver.save(spin_box.value)


func _on_LoadButton_pressed() -> void:
	GameSaver.load(spin_box.value)
	
func _on_Button_pressed():
	visible = not visible
