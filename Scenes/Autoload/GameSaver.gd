# Saves and loads savegame files
# Each node is responsible for finding itself in the save_game
# dict so saves don't rely on the nodes' path or their source file
extends Node

const SaveGame = preload('res://Scenes/Autoload/SavedGame.gd')
# TODO: Use project setting to save to res://debug vs user://
var SAVE_FOLDER: String = "res://debug/save"
var SAVE_NAME_TEMPLATE: String = "save_%03d.tres"
var SAVE_NAME_TEMPLATE_GLOBAL: String = "save_global.tres"

func _ready():
	load_globally()

func save_globally():
	# Passes a SaveGame resource to all nodes to save data from
	# and writes it to the disk
	var save_game := SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	for node in get_tree().get_nodes_in_group('save_globally'):
		node.save(save_game)
	GameSettings.save(save_game)
	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)

	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE_GLOBAL)
	var error: int = ResourceSaver.save(save_path, save_game)
	if error != OK:
		print('There was an issue writing the save %s to %s' % [SAVE_NAME_TEMPLATE_GLOBAL, save_path])


func load_globally():
	# Reads a saved game from the disk and delegates loading
	# to the individual nodes to load
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE_GLOBAL)
	var file: File = File.new()
	print("before check exist")
	print(file.file_exists(save_file_path))
	print("what")
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist" % save_file_path)
		return
	print("after check exist")
	var save_game: Resource = load(save_file_path)
	for node in get_tree().get_nodes_in_group('save_globally'):
		node.load(save_game)
	GameSettings.load(save_game)

func save(id: int):
	# Passes a SaveGame resource to all nodes to save data from
	# and writes it to the disk
	var save_game := SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	for node in get_tree().get_nodes_in_group('save'):
		node.save(save_game)
	Achievements.save(save_game)
	PartyManager.save(save_game)
	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)

	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var error: int = ResourceSaver.save(save_path, save_game)
	if error != OK:
		print('There was an issue writing the save %s to %s' % [id, save_path])


func load(id: int):
	# Reads a saved game from the disk and delegates loading
	# to the individual nodes to load
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file: File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist" % save_file_path)
		return

	var save_game: Resource = load(save_file_path)
	for node in get_tree().get_nodes_in_group('save'):
		node.load(save_game)
	Achievements.load(save_game)
	PartyManager.load(save_game)
