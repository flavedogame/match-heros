extends Control

var dialogues_folder = 'res://DialogueSystem/dialogs/' 

onready var frame : Node = $Frame # The container node for the dialogues.
onready var timer : Node = $Timer # Timer node.
onready var label : Node = $Frame/RichTextLabel # The label where the text will be displayed.
onready var name_left : Node = $Frame/NameLeft
onready var name_right : Node = $Frame/NameRight

var wait_time : float = 0.01 # Time interval (in seconds) for the typewriter effect. Set to 0 to disable it. 
var pause_time : float = 0.4 # Duration of each pause when the typewriter effect is active.
var pause_char : String = '|' # The character used in the JSON file to define where pauses should be. If you change this you'll need to edit all your dialogue files.
var newline_char : String = '@' # The character used in the JSON file to break lines. If you change this you'll need to edit all your dialogue files.
var show_names : bool = true # Turn on and off the character name labels


var id
var next_step = ''
var dialogue
var current = ''
var number_characters : = 0
var phrase = ''
var raw_text = '' #the raw phrase to show after remove pause and new line

var pause_index : = 0
var paused : = false
var pause_array : = []

var init_block
var dialog_id
var typewriting_finished = true

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
	
	pause_search = phrase.find('%s' % pause_char, pause_search)
	
	if pause_search >= 0:
		while pause_search != -1:
			phrase.erase(pause_search,1)
			pause_search = phrase.find('%s' % pause_char, pause_search)
	
	phrase = phrase.split('%s' % newline_char, true, 0) # Splits the phrase using the newline_char as separator
	
	var counter = 0
	label.bbcode_text = ''
	for n in phrase:
		label.bbcode_text = label.get('bbcode_text') + phrase[counter] + '\n'
		counter += 1

func check_names(block):
	if not show_names:
		return
	if block.has('name'):
		if block['position'] == 'left':
			name_left.text = block['name']
			yield(get_tree(), 'idle_frame')
			name_left.rect_size.x = 0
			#name_left.rect_position.x += name_offset.x
			name_left.set_process(true)
			name_left.show()
			name_right.hide()
		else:
			name_right.text = block['name']
			
			yield(get_tree(), 'idle_frame')
			name_right.rect_size.x = 0
			#name_right.rect_position.x = frame_width - name_right.rect_size.x - name_offset.x
			name_right.set_process(true)
			name_right.show()
			name_left.hide()
	else:
		pass

func format_text(text):
	raw_text = text
	check_pauses()
	check_newlines(raw_text)
	clean_bbcode(text)
	number_characters = raw_text.length()

func check_pauses():
	#put all pause character into array and remove from raw_text
	var next_search = 0
	next_search = raw_text.find('%s' % pause_char, next_search)
	
	while next_search != -1:
		pause_array.append(next_search)
		raw_text.erase(next_search, 1)
		next_search = raw_text.find('%s' % pause_char, next_search)
			
func check_newlines(string):
	var line_search = 0
	var line_break_array = []
	var new_pause_array = []
	var current_line = 0
	raw_text = string
	line_search = raw_text.find('%s' % newline_char, line_search)
	
	if line_search >= 0:
		while line_search != -1:
			line_break_array.append(line_search)
			raw_text.erase(line_search,1)
			line_search = raw_text.find('%s' % newline_char, line_search)
	
		for a in pause_array.size():
			if pause_array[a] > line_break_array[current_line]:
				current_line += 1
			new_pause_array.append(pause_array[a]-current_line)
				
		pause_array = new_pause_array

		
func update_dialogue(step): # step == whole dialogue block
	clean()
	current = step
	number_characters = 0 # Resets the counter
	# Check what kind of interaction the block is
	match step['type']:
		'text': # Simple text.
			#not_question()
			var text = step['content']
			AutoCheckTranslation.addTranslation(text)
			text = tr(text)
			format_text(text)
			#check_animation(step)
			check_names(step)
			
			if step.has('next'):
				next_step = step['next']
			else:
				next_step = ''
	
	if wait_time > 0: # Check if the typewriter effect is active and then starts the timer.
		label.visible_characters = 0
		typewriting_finished = false
		timer.start()
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

func _on_Timer_timeout():
	#print("timer out")
	if label.visible_characters < number_characters: # Check if the timer needs to be started
		if paused:
			update_pause()
			return # If in pause, ignore the rest of the function.

		if pause_array.size() > 0: # Check if the phrase have any pauses left.
			if label.visible_characters == pause_array[pause_index]: # pause_char == index of the last character before pause.
				timer.wait_time = pause_time #* wait_time * 10
				paused = true
			else:
				label.visible_characters += 1
		else: # Phrase doesn't have any pauses.
			label.visible_characters += 1
		
		timer.start()
	else:
#		if is_question:
#			choices.get_child(0).self_modulate = active_choice
#		elif dialogue and enable_continue_indicator:
#			animations.play('Continue_Indicator')
#			continue_indicator.show()
		timer.stop()
		typewriting_finished = true
		return
		
func skil_typewriting():
	typewriting_finished = true
	timer.stop()
	label.visible_characters = number_characters

func update_pause():
	if pause_array.size() > (pause_index+1): # Check if the current pause is not the last one. 
		pause_index += 1
	else: # Doesn't have any pauses left.
		pause_array = []
		pause_index = 0
		
	paused = false
	timer.wait_time = wait_time
	timer.start()

func _on_ContinueButton_pressed():
	if not typewriting_finished:
		skil_typewriting()
	else:
		next()
