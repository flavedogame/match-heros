extends Node



static func initialize(battlers: Array) -> void:
	print(battlers)
	for battler in battlers:
		create_lifebar(battler)


static func create_lifebar(battler:Battler) -> void:
	var HookableLifebar = preload("res://Scenes/battle/hookableUI/HookableLifeBar.tscn")
	print("create lifebar")
	var lifebar = HookableLifebar.instance()
	print(battler.skin)
	print(battler.bars)
	battler.bars.add_child(lifebar)
	lifebar.initialize(battler)
