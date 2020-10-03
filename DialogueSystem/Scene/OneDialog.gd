extends TextureRect


onready var label : Node = $RichTextLabel # The label where the text will be displayed.
onready var name_left : Node = $NameLeft
onready var name_right : Node = $NameRight

onready var timer : Node = $Timer # Timer node.


var wait_time : float = 0.01 # Time interval (in seconds) for the typewriter effect. Set to 0 to disable it. 
var pause_time : float = 0.4 # Duration of each pause when the typewriter effect is active.
var pause_char : String = '|' # The character used in the JSON file to define where pauses should be. If you change this you'll need to edit all your dialogue files.
var newline_char : String = '@' # The character used in the JSON file to break lines. If you change this you'll need to edit all your dialogue files.
var show_names : bool = true # Turn on and off the character name labels


var number_characters : = 0
var phrase = ''
var raw_text = '' #the raw phrase to show after remove pause and new line


var pause_index : = 0
var paused : = false
var pause_array : = []
var step


var typewriting_finished = true


#func clean(): # Resets some variables to prevent errors.
##	continue_indicator.hide()
##	animations.stop()
##	paused = false
##	pause_index = 0
##	pause_array = []
##	current_choice = 0
#	timer.wait_time = wait_time # Resets the typewriter effect delay

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
		
func _ready():
	
	#clean()
	#current = step
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
			
#			if step.has('next'):
#				next_step = step['next']
#			else:
#				next_step = ''
	
	if wait_time > 0: # Check if the typewriter effect is active and then starts the timer.
		label.visible_characters = 0
		typewriting_finished = false
		timer.wait_time = wait_time
		timer.start()
#	elif enable_continue_indicator: # If typewriter effect is disabled check if the ContinueIndicator should be displayed
#		continue_indicator.show()
#		animations.play('Continue_Indicator')

func init(_step): # step == whole dialogue block
	
	step = _step

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
		
#return if typewriting has already stopped
func stop_typewriting():
	if typewriting_finished:
		return true
	typewriting_finished = true
	timer.stop()
	label.visible_characters = number_characters
	return false

func update_pause():
	if pause_array.size() > (pause_index+1): # Check if the current pause is not the last one. 
		pause_index += 1
	else: # Doesn't have any pauses left.
		pause_array = []
		pause_index = 0
		
	paused = false
	timer.wait_time = wait_time
	timer.start()
