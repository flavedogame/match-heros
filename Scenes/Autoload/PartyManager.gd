extends Node

var party:PartyStats



var SAVE_KEY = "Party"



func get_battle_party_members():
	var result = {}
	for key in party.battle_positon_to_party_members:
		var value = party.battle_positon_to_party_members[key]
		var party_member_info = load("res://resources/party/"+value+".tres")
		result[key] = party_member_info
	return result

func _ready():
	party = load("res://resources/party/party.tres")
	
func add_party_member(party_member_id):
	Events.emit_signal("show_popup_message",party_member_id+" joined team!")
	if party.party_members.has(party_member_id):
		push_error("should not add party member again %s"%party_member_id)
	party.party_members[party_member_id] = null
	#remove this later
	add_party_member_in_battle(party_member_id,"1")
	
func add_party_member_in_battle(party_member_id, position):
	if party.battle_positon_to_party_members.has(position):
		var old_party_member = party.battle_positon_to_party_members[position]
		party.party_members[old_party_member] = null
	party.battle_positon_to_party_members[position] = party_member_id
	party.party_members[party_member_id] = position
	
	
func save(saved_game: Resource):
	saved_game.data[SAVE_KEY] = party
	
func load(saved_game: Resource):
	party = saved_game.data[SAVE_KEY]
	if party == null:
		party = load("res://resources/party/party.tres")
	Events.emit_signal("achievement_update")
