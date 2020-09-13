extends Node

var actors
var targets

var is_attacking = false

signal finished_attack
	
func attack(actor, targets, attack_value):
	if actor.party_member and not targets:
		return false
	if attack_value == 0:
		return false
		
	is_attacking = true
	for target in targets:
		var hit = Hit.new(actor.stats.strength * attack_value)
		yield(actor.skin.move_to(target), "completed")
		target.take_damage(hit)
		yield(actor.get_tree().create_timer(1.0), "timeout")
		yield(actor.skin.return_to_start(), "completed")
	print("finish attack")
	emit_signal("finished_attack")
	is_attacking = false
	return true

func choose_action(_actors, _targets):
	print("hmm?")
	actors = _actors
	targets = _targets
	yield($"../../grid","finish_a_move")
	print("finished a move")
	return
	
func _on_grid_make_a_move(move_details):
	print("on grid make a move")
	var attack_value = move_details.get("orange",0)
	attack(actors[0], targets, attack_value)

func is_finished():
	for actor in actors:
		print(actor.name)
		yield(actor.is_finished(),"completed")
		if is_attacking:
			print("wait for finish attack")
			yield(self,"finished_attack")
			
			print("wait for finish attack finished")
	return
