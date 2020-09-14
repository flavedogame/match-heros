extends Node2D

#state machine
enum {wait, move}
var state

export (int) var width = 8
export (int) var height = 10
export (int) var x_start = 64
export (int) var y_start = 950
export (int) var offset = 64
#where the piece should drop from
export (int) var y_offset = -2


export (PoolVector2Array) var empty_spaces = [
#	Vector2(0,0),
#	Vector2(width-1,height-1),
#	Vector2(0,height-1),
#	Vector2(width-1,0), 
#	Vector2((width-1)/2,(height-1)/2),
#	Vector2((width-1)/2+1,(height-1)/2),
#	Vector2((width-1)/2,(height-1)/2+1),
#	Vector2((width-1)/2+1,(height-1)/2+1),
]

var all_pieces = []
var current_matches = {
}

var possible_pieces = [
	preload("res://Scenes/match_3_game/pieces/yellow_piece.tscn"),
	preload("res://Scenes/match_3_game/pieces/blue_piece.tscn"),
	preload("res://Scenes/match_3_game/pieces/orange_piece.tscn"),
	preload("res://Scenes/match_3_game/pieces/pink_piece.tscn"),
	#preload("res://Scenes/match_3_game/pieces/green_piece.tscn"),
	#preload("res://Scenes/match_3_game/pieces/lightgreen_piece.tscn"),
]

#touch variables
var first_touch = Vector2(0,0)
var final_touch = Vector2(0,0)
var first_piece
var final_piece
var controlling = false

onready var pieces_parent = $pieces_parent

#scoreing variables
#signal update_score
signal piece_destroyed
export (int) var piece_value = 10
var streak = 1

var battle_scene :BattleScene

var particle_effect = preload("res://Scenes/match_3_game/destory_piece_particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	state = move
	randomize()
	all_pieces = make_2d_array()
	spawn_pieces()
	toggle_disable_layers(false)
	
	
func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array
	
func add_to_current_matches(value, color):
	if not current_matches.has(color):
		current_matches[color] = []
	add_to_unique_array(value,current_matches[color])
	
func add_to_unique_array(value, array_to_add = current_matches):
	if not array_to_add.has(value):
		array_to_add.append(value)
		
	
func spawn_one_piece(i,j,should_check = true):
	var rand = randi() % possible_pieces.size()
	var piece = possible_pieces[rand].instance()
	# todo: here when refill we did not check if it could match and destory
	# the problem is the refill part might match themselves and might cause unreasonable match
	if should_check:
	#if true:
		var loops = 0
		while(is_match_at(i,j,piece.color)&& loops<100):
			rand = randi() % possible_pieces.size()
			loops+=1
			piece = possible_pieces[rand].instance()
	pieces_parent.add_child(piece)
	piece.position = grid_to_pixel(i,j-y_offset)
	piece.move(grid_to_pixel(i,j))
	all_pieces[i][j] = piece
	
func restricted_movement(grid_point):
	for i in empty_spaces:
		if i == grid_point:
#	if empty_spaces.has(grid_point):
			return true
	return false

func spawn_pieces():
	for i in width:
		for j in height:
			if not restricted_movement(Vector2(i,j)):
				spawn_one_piece(i,j)
			

	
func grid_to_pixel(column, row):
	var new_x = x_start+offset*column
	var new_y = y_start-offset*row
	return Vector2(new_x,new_y)
	
func pixel_to_grid(x,y):
	var new_x = round((x - x_start) / offset)
	var new_y = round((y - y_start) / -offset)
	return Vector2(new_x,new_y)
	
func is_in_grid(column, row):
	if column >=0 && column<width:
		if row>=0 && row<height:
			return true
	return false

func is_match_at(i, j, color):
	if i >1:
		if all_pieces[i-1][j] !=null && all_pieces[i-2][j]!=null:
			if all_pieces[i-1][j].color == color and all_pieces[i-2][j].color == color:
				return true
	if j >1:
		if all_pieces[i][j-1] !=null && all_pieces[i][j-2]!=null:
			if all_pieces[i][j-1].color == color and all_pieces[i][j-2].color == color:
				return true
	return false
	
func is_match_at2(i, j, color,callback):
	var isMatched = false
	if i >1:
		if all_pieces[i-1][j] !=null && all_pieces[i-2][j]!=null:
			if all_pieces[i-1][j].color == color and all_pieces[i-2][j].color == color:
				all_pieces[i][j].call(callback)
				all_pieces[i-1][j].call(callback)
				all_pieces[i-2][j].call(callback)
				add_to_current_matches(Vector2(i,j),color)
				add_to_current_matches(Vector2(i-1,j),color)
				add_to_current_matches(Vector2(i-2,j),color)
				isMatched = true
				#return true
	if j>1:
		if all_pieces[i][j-1] !=null && all_pieces[i][j-2]!=null:
			if all_pieces[i][j-1].color == color and all_pieces[i][j-2].color == color:
				all_pieces[i][j].call(callback)
				all_pieces[i][j-1].call(callback)
				all_pieces[i][j-2].call(callback)
				add_to_current_matches(Vector2(i,j),color)
				add_to_current_matches(Vector2(i,j-1),color)
				add_to_current_matches(Vector2(i,j-2),color)
				isMatched = true
				#return true
	#return false
	return isMatched
	
func _input(event):
	if state != move:
		return
	if event is InputEventScreenTouch and event.pressed:
		first_touch = event.position
		var grid_position = pixel_to_grid(first_touch.x,first_touch.y)
		print(grid_position)
		if is_in_grid(grid_position.x,grid_position.y):
			print("in grid")
			controlling = true
		else:
			print("not in grid")
	if controlling:
		if event is InputEventScreenTouch and not event.pressed:
			final_touch = event.position
			var direction = touch_direction(first_touch,final_touch)
			var grid_position = pixel_to_grid(first_touch.x,first_touch.y)
			swap_pieces(grid_position.x,grid_position.y,direction)
			controlling = false
		
func swap_pieces(column, row, direction):
	var new_column = column + direction.x
	var new_row = row+direction.y
	if not is_in_grid(new_column, new_row):
		return
	first_piece = all_pieces[column][row]
	final_piece = all_pieces[new_column][new_row]
	if first_piece == null or final_piece == null:
		return
	state = wait
	
	all_pieces[column][row] = final_piece
	all_pieces[new_column][new_row] = first_piece
	first_piece.move(grid_to_pixel(new_column,new_row))
	final_piece.move(grid_to_pixel(column,row))
	first_piece.set_grid_position(new_column,new_row)
	final_piece.set_grid_position(column,row)
	var found_color_bomb = match_color_bomb()
	if found_color_bomb:
		start_destory()
		return
	
	var found_matches = find_matches()
	if not found_matches and not found_color_bomb:
		yield(get_tree().create_timer(0.15), "timeout")
		swap_back(column,row,new_column,new_row)
		
func match_color_bomb(): 
	if first_piece.color == "Color" and final_piece.color == "Color":
		match_board()
		return true
	elif first_piece.color == "Color":
		match_color(final_piece.color)
		first_piece.set_matched()
		return true
	elif final_piece.color == "Color":
		match_color(first_piece.color)
		final_piece.set_matched()
		return true
	return false
	
func start_destory():
	trigger_bombed_pieces()
	$destroy_timer.start()

func swap_back(column,row,new_column,new_row):
	var first_piece = all_pieces[column][row]
	var final_piece = all_pieces[new_column][new_row]
	all_pieces[column][row] = final_piece
	all_pieces[new_column][new_row] = first_piece
	first_piece.move(grid_to_pixel(new_column,new_row))
	final_piece.move(grid_to_pixel(column,row))
	yield(get_tree().create_timer(0.15), "timeout")
	state = move
	
	
func touch_direction(touch1,touch2):
	var diff = touch2-touch1
	var direction = Vector2()
	if abs(diff.x)>abs(diff.y):
		direction = Vector2(1 if diff.x>0 else -1,0)
	if abs(diff.y)>abs(diff.x):
		direction = Vector2(0,1 if diff.y<0 else -1)
	return direction

func find_matches():
	var found_matched = false
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				var current_color = all_pieces[i][j].color
				if is_match_at2(i,j,current_color,"set_matched"):
					found_matched = true
	if found_matched:
		#print("foundMatched")
		# todo keep trigger bomb
		trigger_bombed_pieces()
		$destroy_timer.start()
	else:
		#print("not foundMatched")
		pass
		#after_refill()
	return found_matched

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if state == move:
#		touch_input()

func find_match_line_with_direction(vec2, direction, match_count, current_match):
	var success = true
	for i in match_count-1:
		vec2 += direction
		if not current_match.has(vec2):
			success = false
			break
	#print(vec2, match_count,direction, success)
	return success
	
func find_match_line_centered(vec2, is_horizontal, current_match):
	var direction = Vector2(1,0) if is_horizontal else Vector2(0,1)
	return current_match.has(vec2+direction) and current_match.has(vec2-direction)

func find_match_line(vec2, is_horizontal, match_count, current_match):
	var direction = Vector2(1,0) if is_horizontal else Vector2(0,1)
	
	return find_match_line_with_direction(vec2,direction,match_count,current_match) or \
			find_match_line_with_direction(vec2,-direction,match_count,current_match) 
	

func find_match_5(vec2,current_match):
	return find_match_line(vec2,true,5,current_match) or find_match_line(vec2,false,5,current_match)
	
func find_match_L(vec2,current_match):
	return find_match_line(vec2, true, 3,current_match) and find_match_line(vec2, false, 3,current_match)

func find_match_T(vec2,current_match):
	return (find_match_line(vec2, true, 3,current_match) and find_match_line_centered(vec2, false, current_match)) or \
			(find_match_line(vec2, false, 3,current_match) and find_match_line_centered(vec2, true, current_match))
			
func find_match_cross(vec2,current_match):
	return find_match_line_centered(vec2, false, current_match) and find_match_line_centered(vec2, true, current_match)
	
func find_match_adj(vec2,current_match):
	return find_match_L(vec2,current_match) or find_match_T(vec2,current_match) or find_match_cross(vec2,current_match)

func find_bombs():
	# for each one in current matches:
	# for each one, add all adjacent ones that can match 3, put all of them into a list
	# in this list, find 5 match first, generate bomb at center
	# find L or T, generate bomb at coner or center
	# find 4 match, generate at swap or one end(it should be the last drop one) 
	
	#too lazy to refactor this
	
	for current_match in current_matches.values():
		for i in current_match:
			var x = i.x
			var y = i.y
			var color = all_pieces[x][y].color
			if find_match_5(i,current_match):
				make_bomb(3,i,current_match)
				return
				
	for current_match in current_matches.values():
		for i in current_match:
			var x = i.x
			var y = i.y
			var color = all_pieces[x][y].color	
			if find_match_line(i,false,4,current_match):
				make_bomb(1, i,current_match)
				return
				
	for current_match in current_matches.values():
		for i in current_match:
			var x = i.x
			var y = i.y
			var color = all_pieces[x][y].color
			if find_match_line(i,true,4,current_match):
				make_bomb(2, i,current_match)
				return
				
	for current_match in current_matches.values():
		for i in current_match:
			var x = i.x
			var y = i.y
			var color = all_pieces[x][y].color
			if find_match_adj(i,current_match):
				make_bomb(0, i,current_match)
				return
				
				
func make_bomb(bomb_type, vec2,current_match):
	#if swap is in this match, generate at swap position
	var bomb_piece = all_pieces[vec2.x][vec2.y]
	#print(current_match, first_piece,final_piece)
	if first_piece and current_match.has(first_piece.grid_position):
		bomb_piece = first_piece
	if final_piece and current_match.has(final_piece.grid_position):
		bomb_piece = final_piece
	change_bomb(bomb_type, bomb_piece)
			
func trigger_bombed_pieces():
	for i in width:
		for j in height:
			if all_pieces[i][j]!=null:
				if all_pieces[i][j].matched:
					match_bombs(i,j)
					
func match_bombs(i,j):
	var bomb_piece = all_pieces[i][j]
	if all_pieces[i][j].is_bomb_triggered:
		return
	if all_pieces[i][j].is_col_bomb:
		
		all_pieces[i][j].is_bomb_triggered = true
		match_all_in_col(i)
	elif all_pieces[i][j].is_row_bomb:
		all_pieces[i][j].is_bomb_triggered = true
		match_all_in_row(j)
	elif all_pieces[i][j].is_adj_bomb:
		all_pieces[i][j].is_bomb_triggered = true
		match_all_adjacent(i,j) 
	elif all_pieces[i][j].is_color_bomb:
		all_pieces[i][j].is_bomb_triggered = true
		match_all_adjacent(i,j) 
		
func match_all_in_row(row):
	for i in width:
		if all_pieces[i][row] !=null:
			if all_pieces[i][row].is_color_bomb:
				continue
			all_pieces[i][row].set_matched()
			match_bombs(i,row)

func match_all_in_col(col):
	#print("match_all_in_col")
	for i in height:
		if all_pieces[col][i] !=null:
			if all_pieces[col][i].is_color_bomb:
				continue
			all_pieces[col][i].set_matched()
			match_bombs(col,i)
			
func match_all_adjacent(column,row):
	for i in range(-1,2):
		for j in range(-1,2):
			if is_in_grid(column+i, row+j):
				if all_pieces[column+i][row+j] !=null:
					if all_pieces[column+i][row+j].is_color_bomb:
						continue
					all_pieces[column+i][row+j].set_matched()
					match_bombs(i,j)
					
func match_color(color):
	for i in width:
		for j in height:
			if all_pieces[i][j] and all_pieces[i][j].color == color:
				all_pieces[i][j].set_matched()
				match_bombs(i,j)

func match_board():
	for i in width:
		for j in height:
			all_pieces[i][j].set_matched()

func change_bomb(bombType,piece):
	#print("change bomb",bombType,piece)
	#emit_signal("update_score",piece_value*streak)
	#hmm maybe another one
	#make_effect(particle_effect,i,j)
	match bombType:
		0:
			piece.make_adj_bomb()
		1:
			piece.make_col_bomb()
		2:
			piece.make_row_bomb()
		3:
			piece.make_color_bomb()

func destroy_matched():
	#print(current_matches)
	find_bombs()
	current_matches.clear()
	var move_info =  {}
	for i in width:
		for j in height:
			if all_pieces[i][j] !=null:
				if all_pieces[i][j].matched:
					var color = all_pieces[i][j].color
					if not move_info.has(color):
						move_info[color] = 0
					move_info[color] += 1
					
					make_effect(particle_effect,i,j)
					all_pieces[i][j].queue_free()
					all_pieces[i][j] = null
					#emit_signal("update_score",piece_value*streak)
	# todo: generate bomb should destroy the old one then create new one, to avoid problems
	
	yield(battle_scene.party_attack(move_info),"completed")
	$collapse_timer.start()

func collapse_columns():
	#print("collapse_columns")
	for i in width:
		for j in height:
			if all_pieces[i][j] == null and not restricted_movement(Vector2(i,j)):
				for k in range(j+1,height):
					if all_pieces[i][k]!=null:
						all_pieces[i][k].move(grid_to_pixel(i,j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	$refill_timer.start()
						
func refill_columns():
	#print("refill_columns")
	streak+=1
	for i in width:
		for j in height:
			if all_pieces[i][j] == null and not restricted_movement(Vector2(i,j)):
				spawn_one_piece(i,j,false)
	after_refill()

func toggle_disable_layers(is_disabled):
	for i in width:
		for j in height:
			all_pieces[i][j].set_disabled(is_disabled)
	

func after_refill():
	
	#clear swap info
	first_piece = null
	final_piece = null
	#print("after_refill")
	print("battle scene completed")
	#wait until battle scene finished attack & anim
	var foundMatched = find_matches()
	if not foundMatched:
		#set state when enmey finish move
		
		toggle_disable_layers(true)
		
		yield(battle_scene.enemy_attack(),"completed")
		toggle_disable_layers(false)
		state = move
	streak = 1
	
func make_effect(effect, column, row):
	var current = effect.instance()
	current.position = grid_to_pixel(column, row)
	pieces_parent.add_child(current)
	emit_signal("piece_destroyed",current.position, all_pieces[column][row].color, all_pieces[column][row].sprite.texture)
	

func _on_destroy_timer_timeout():
	destroy_matched()


func _on_collapse_timer_timeout():
	collapse_columns()


func _on_refill_timer_timeout():
	refill_columns()
