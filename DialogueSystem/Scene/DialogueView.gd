extends Control

var dialogues_folder = 'res://DialogueSystem/dialogs/' 
var one_dialog_scene = preload("res://DialogueSystem/Scene/OneDialog.tscn")

onready var frame : Node = $Frame # The container node for the dialogues.
onready var dialogs:VBoxContainer = $Frame/VScrollBar/dialogs
onready var scroll_container = $Frame/VScrollBar

var id
var next_step = ''
var dialogue
var current = ''

var current_one_dialog

var init_block
var dialog_id

func _ready():
	first(init_block)

func init(_dialog_id, file_id, block = 'first'): # Load the whole dialogue into a variable
	dialog_id = _dialog_id
	id = file_id
	init_block = block
	var file = File.new()
	var file_path = '%s/%s.json' % [dialogues_folder, id]
	print(file_path)
	file.open(file_path, file.READ)
	var json = file.get_as_text()
	dialogue = JSON.parse(json).result
	var error = JSON.parse(json).error
	if error != OK:
		print(JSON.parse(json).error_string)
	file.close()

func first(block):
	frame.show()
	if block == 'first': # Check if we are going to use the default 'first' block
#		if dialogue.has('repeat'):
#			if progress.get(dialogues_dict).has(id): # Checks if it's the first interaction.
#				update_dialogue(dialogue['repeat']) # It's not. Use the 'repeat' block.
#			else:
#				progress.get(dialogues_dict)[id] = true # Updates the singleton containing the interactions log.
#				update_dialogue(dialogue['first']) # It is. Use the 'first' block.
#		else:
			add_dialog(dialogue['first'])
	else: # We are going to use a custom first block
		add_dialog(dialogue[block])


func add_dialog(step):
	var one_dialog_instance = one_dialog_scene.instance()
	
	one_dialog_instance.init(step)
	dialogs.add_child(one_dialog_instance)
	#todo make 300 a reasonable value
	dialogs.rect_min_size.y = dialogs.rect_min_size.y+300
	yield(get_tree(),"idle_frame")
	scroll_container.scroll_to(dialogs.rect_min_size.y - 620)
	current_one_dialog = one_dialog_instance
	
	if step.has('next'):
		next_step = step['next']
	else:
		next_step = ''

func next():
	if not dialogue:# or on_animation: # Check if is in the middle of a dialogue 
		return
	#clean() # Be sure all the variables used before are restored to their default values.
#	if wait_time > 0: # Check if the typewriter effect is active.
#		if label.visible_characters < number_characters: # Checks if the phrase is complete.
#			label.visible_characters = number_characters # Finishes the phrase.
#			return # Stop the function here.
#	else: # The typewriter effect is disabled so we need to make sure the text is fully displayed.
#		label.visible_characters = -1 # -1 tells the RichTextLabel to show all the characters.
#
	if next_step == '': # Doesn't have a 'next' block.
#		if current.has('animation_out'):
#			animate_sprite(current['position'], current['avatar'], current['animation_out'])
#			yield(tween, "tween_completed")
#		else:
#			sprite_left.modulate = white_transparent
#			sprite_right.modulate = white_transparent
		dialogue = null
#		name_left.hide()
#		name_right.hide()
#		frame.hide() 
#		avatar_left = ''
#		avatar_right = ''
		Events.emit_signal("finish_dialog",dialog_id)
		self.queue_free()
	else:
		#label.bbcode_text = ''
#		if choices.get_child_count() > 0: # If has choices, remove them.
#			for n in choices.get_children():
#				choices.remove_child(n)
#		else:
#			pass
#		if current.has('animation_out'):
#			animate_sprite(current['position'], current['avatar'], current['animation_out'])
#			yield(tween, "tween_completed")
		
		add_dialog(dialogue[next_step])



func _on_VScrollBar_click_scrollbar():
	print(current_one_dialog)
	var already_stoped = current_one_dialog.stop_typewriting()
	if already_stoped:
		next()


