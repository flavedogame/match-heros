extends Node

func attack(actors, targets):
	yield(get_tree(), "idle_frame")
	var actor = actors[0]
	if actor.party_member and not targets:
		return false
	var target = targets[0]
	yield(actor.attack(target,null),"completed")
		
	return true
