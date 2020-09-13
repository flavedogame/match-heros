extends Node

#var actors
#var targets

signal finished_attack
	
func attack(actors, targets, move_details):
	print("party ai attack")
	yield(get_tree(), "idle_frame")
	var actor = actors[0]
	if actor.party_member and not targets:
		print("should not be here")
		return false
	var target = targets[0]
	yield(actor.attack(target,move_details),"completed")
		
	return true

