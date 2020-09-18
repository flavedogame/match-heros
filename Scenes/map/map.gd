extends Node2D

class_name Map

signal enemies_encountered(formation)

func start_encounter(formation) -> void:
	emit_signal("enemies_encountered", formation)
