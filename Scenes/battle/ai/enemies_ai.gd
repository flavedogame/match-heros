extends Node

func choose_action(actors, targets):
	var target = targets[0]
	for actor in actors:
		print(actor,target)
		var hit = Hit.new(actor.stats.strength)
		yield(actor.skin.move_to(target), "completed")
		target.take_damage(hit)
		yield(actor.get_tree().create_timer(1.0), "timeout")
		yield(actor.skin.return_to_start(), "completed")
	return
