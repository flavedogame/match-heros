extends Node

func get_target(targets):
	for target in targets:
		if target.is_alive:
			return target
	return null
	
func attack(actors, targets):
	yield(get_tree(), "idle_frame")
	for actor in actors:
		if actor.is_alive:
			var target = get_target(targets)
			if not target:
				push_warning("no target!!")
				break
			yield(actor.attack(target,null),"completed")
		
	return true
