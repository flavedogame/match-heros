extends Control

var dialogues_folder = 'res://DialogueSystem/dialogs/' 

onready var frame : Node = $Frame # The container node for the dialogues.
onready var timer : Node = $Timer # Timer node.
onready var label : Node = $Frame/RichTextLabel # The label where the text will be displayed.

var wait_time : float = 0.02 # Time interval (in seconds) for the typewriter effect. Set to 0 to disable it. 



var id
var next_step = ''
var dialogue
var current = ''
var number_characters : = 0
var phrase = ''
var phrase_raw = ''

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
	print("file closed")

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
			update_dialogue(dialogue['first'])
	else: # We are going to use a custom first block
		update_dialogue(dialogue[block])

func clean(): # Resets some variables to prevent errors.
#	continue_indicator.hide()
#	animations.stop()
#	paused = false
#	pause_index = 0
#	pause_array = []
#	current_choice = 0
	timer.wait_time = wait_time # Resets the typewriter effect delay

func clean_bbcode(string):
	phrase = string
	var pause_search = 0
	var line_search = 0
	
#	pause_search = phrase.find('%s' % pause_char, pause_search)
#
#	if pause_search >= 0:
#		while pause_search != -1:
#			phrase.erase(pause_search,1)
#			pause_search = phrase.find('%s' % pause_char, pause_search)
#
#	phrase = phrase.split('%s' % newline_char, true, 0) # Splits the phrase using the newline_char as separator
#
	var counter = 0
	label.bbcode_text = ''
	for n in phrase:
		label.bbcode_text = label.get('bbcode_text') + phrase[counter] + '\n'
		counter += 1

func update_dialogue(step): # step == whole dialogue block
	clean()
	current = step
	number_characters = 0 # Resets the counter
	# Check what kind of interaction the block is
	match step['type']:
		'text': # Simple text.
			#not_question()
			label.bbcode_text = step['content']
			#check_pauses(label.get_text())
			#check_newlines(phrase_raw)
			#clean_bbcode(step['content'])
			number_characters = phrase_raw.length()
			#check_animation(step)
			#check_names(step)
			
			if step.has('next'):
				next_step = step['next']
			else:
				next_step = ''
	
#	if wait_time > 0: # Check if the typewriter effect is active and then starts the timer.
#		label.visible_characters = 0
#		timer.start()
#	elif enable_continue_indicator: # If typewriter effect is disabled check if the ContinueIndicator should be displayed
#		continue_indicator.show()
#		animations.play('Continue_Indicator')
func next():
	if not dialogue:# or on_animation: # Check if is in the middle of a dialogue 
		return
	clean() # Be sure all the variables used before are restored to their default values.
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
		label.bbcode_text = ''
#		if choices.get_child_count() > 0: # If has choices, remove them.
#			for n in choices.get_children():
#				choices.remove_child(n)
#		else:
#			pass
#		if current.has('animation_out'):
#			animate_sprite(current['position'], current['avatar'], current['animation_out'])
#			yield(tween, "tween_completed")
		
		update_dialogue(dialogue[next_step])

func _on_ContinueButton_pressed():
	next()