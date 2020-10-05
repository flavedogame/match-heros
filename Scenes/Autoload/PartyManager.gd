extends Node

var party:PartyStats


var SAVE_KEY = "Party"

func get_battle_party_members():
	return party.battle_party_members

func _ready():
	party = load("res://resources/party/party.tres")
	
func save(saved_game: Resource):
	saved_game.data[SAVE_KEY] = party
	
func load(saved_game: Resource):
	party = saved_game.data[SAVE_KEY]
	if party == null:
		party = load("res://resources/party/party.tres")
	Events.emit_signal("achievement_update")
