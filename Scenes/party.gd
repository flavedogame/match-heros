extends Node2D

class_name Party

export var PARTY_SIZE: int = 3

func get_active_members():
	# Returns the first unlocked children as a dictionary
	# player: position
	var active = {}
	for position in get_children():
		for member in position.get_children():
			if member.visible:
				active[member] = position.name
	print(active)
	return active

