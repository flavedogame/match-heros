tool
extends CanvasLayer


onready var anim_player = $transition_color/AnimationPlayer
onready var transition_color = $transition_color

export (float, 0.0, 1.0) var transition: float = 0.0 setget set_transition
export (float, 0.0, 1.0) var smoothness: float = 0.0 setget set_smoothness


func set_transition(value):
	transition_color.transition = value
	transition_color.material.set('shader_param/cutoff', 1.0 - value)


func set_smoothness(value):
	transition_color.smoothness = value
	transition_color.material.set('shader_param/smooth_size', value)


func fade_to_color():
	anim_player.play("to_color")
	yield(anim_player, "animation_finished")


func fade_from_color():
	anim_player.play("to_transparent")
	yield(anim_player, "animation_finished")
