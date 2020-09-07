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
var current_matches = []

var possible_pieces = [
	preload("res://Scenes/yellow_piece.tscn"),
	preload("res://Scenes/blue_piece.tscn"),
	preload("res://Scenes/orange_piece.tscn"),
	preload("res://Scenes/pink_piece.tscn"),
	#preload("res://Scenes/green_piece.tscn"),
	#preload("res://Scenes/lightgreen_piece.tscn"),
]

#touch variables
var first_touch = Vector2(0,0)
var final_touch = Vector2(0,0)
var first_piece
var final_piece
var controlling = false

#scoreing variables
signal update_score
export (int) var piece_value = 10
var streak = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	state = move
	randomize()
	all_pieces = make_2d_array()
	spawn_pieces()
	
func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array
	
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
	add_child(piece)
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
				add_to_unique_array(Vector2(i,j))
				add_to_unique_array(Vector2(i-1,j))
				add_to_unique_array(Vector2(i-2,j))
				isMatched = true
				#return true
	if j>1:
		if all_pieces[i][j-1] !=null && all_pieces[i][j-2]!=null:
			if all_pieces[i][j-1].color == color and all_pieces[i][j-2].color == color:
				all_pieces[i][j].call(callback)
				all_pieces[i][j-1].call(callback)
				all_pieces[i][j-2].call(callback)
				add_to_unique_array(Vector2(i,j))
				add_to_unique_array(Vector2(i,j-1))
				add_to_unique_array(Vector2(i,j-2))
				isMatched = true
				#return true
	#return false
	return isMatched
	
func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		first_touch = get_global_mouse_position()
		var grid_position = pixel_to_grid(first_touch.x,first_touch.y)
		print(grid_position)
		if is_in_grid(grid_position.x,grid_position.y):
			print("in grid")
			controlling = true
		else:
			print("not in grid")
	if controlling:
		if Input.is_action_just_released("ui_touch"):
			final_touch = get_global_mouse_position()
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
		print("foundMatched")
		# todo keep trigger bomb
		trigger_bombed_pieces()
		$destroy_timer.start()
	else:
		print("not foundMatched")
		#after_refill()
	return found_matched

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == move:
		touch_input()
		
#func get_adjacent(i,j,adjacent):
#	var new_i = i+adjacent.x
#	var new_j = j+adjacent.y
#	if is_in_grid(new_i,new_j):
#		return all_pieces[new_i][new_j]
#	return null
#
#func get_adjacent_ij(i,j,adjacent):
#	var new_i = i+adjacent.x
#	var new_j = j+adjacent.y
#	return Vector2(new_i,new_j)
#
#func find_match_3(i,j,isHorizon):
#	var adjacent = Vector2(1,0) if isHorizon else Vector2(0,1)
#	var color = all_pieces[i][j].color
#	var adjacent_piece_1 = get_adjacent(i,j,adjacent)
#	var adjacent_piece_2 = get_adjacent(i,j,-adjacent)
#	return adjacent_piece_1 and adjacent_piece_1.color == color and adjacent_piece_2 and adjacent_piece_2.color == color
#
#func find_bombs():
#	#var isHorizon = true
#	for isHorizon in [true,false]:
#		var adjacent = Vector2(1,0) if isHorizon else Vector2(0,1)
#		for current_match in current_matches:
#			var i = current_match.x
#			var j = current_match.y
#			if find_match_3(i,j,isHorizon):
#				var adjacent_ij_1 = get_adjacent_ij(i,j,adjacent)
#				var adjacent_ij_2 = get_adjacent_ij(i,j,-adjacent)
#				var found_match3_1 = find_match_3(adjacent_ij_1.x,adjacent_ij_1.y,isHorizon)
#				var found_match3_2 = find_match_3(adjacent_ij_2.x,adjacent_ij_2.y,isHorizon)
#				if found_match3_1 and found_match3_2:
#					print("bomb 5")
#				elif found_match3_1 or found_match3_2:
#					print("bomb 4")
#
#				#var new_adjacent = Vector2(1,0) if not isHorizon else Vector2(0,1)
#
#				var found_match3_1_new = find_match_3(adjacent_ij_1.x,adjacent_ij_1.y,not isHorizon)
#				var found_match3_2_new = find_match_3(adjacent_ij_2.x,adjacent_ij_2.y,not isHorizon)
#				if found_match3_1_new or found_match3_2_new:
#					print("bomb T")

func find_bombs():
	# for each one in current matches:
	# for each one, add all adjacent ones that can match 3, put all of them into a list
	# in this list, find 5 match first, generate bomb at center
	# find L or T, generate bomb at coner or center
	# find 4 match, generate at swap or one end(it should be the last drop one) 
	for i in current_matches:
		var x = i.x
		var y = i.y
		var color = all_pieces[x][y].color
		var x_matched = 0
		var y_matched = 0
		# todo this algorithm does not consider there might be interval in two same color
		# piece get matched
		for j in current_matches:
			var this_x = j.x
			var this_y = j.y
			var this_color = all_pieces[this_x][this_y].color
			if this_x == x and this_color == color:
				x_matched+=1
			if this_y == y and this_color == color:
				y_matched+=1
		if x_matched == 5 or y_matched == 5:
			make_bomb(3, color)
			return
		if y_matched == 3 and x_matched == 3:
			print(" adj bomb")
			make_bomb(0, color)
			return
		if x_matched == 4:
			print("col bomb")
			make_bomb(1, color)
			return
		if y_matched == 4:
			print("row bomb")
			make_bomb(2, color)
			return
				
func make_bomb(bomb_type, color):
	# todo: this does not consider bomb generated later
	for i in current_matches:
		var x = i.x
		var y = i.y
		# todo: oh boy this is totally wrong
		if all_pieces[x][y] == first_piece:
			change_bomb(bomb_type, first_piece)
		if all_pieces[x][y] == final_piece:
			change_bomb(bomb_type, final_piece)
			
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
			all_pieces[i][row].matched = true
			match_bombs(i,row)

func match_all_in_col(col):
	print("match_all_in_col")
	for i in height:
		if all_pieces[col][i] !=null:
			if all_pieces[col][i].is_color_bomb:
				continue
			all_pieces[col][i].matched = true
			match_bombs(col,i)
			
func match_all_adjacent(column,row):
	for i in range(-1,2):
		for j in range(-1,2):
			if is_in_grid(column+i, row+j):
				if all_pieces[column+i][row+j] !=null:
					if all_pieces[column+i][row+j].is_color_bomb:
						continue
					all_pieces[column+i][row+j].matched = true
					match_bombs(i,j)
					
func match_color(color):
	for i in width:
		for j in height:
			if all_pieces[i][j] and all_pieces[i][j].color == color:
				all_pieces[i][j].matched = true
				match_bombs(i,j)

func match_board():
	for i in width:
		for j in height:
			all_pieces[i][j].matched = true

func change_bomb(bombType,piece):
	piece.matched = false
	print("change bomb",bombType,piece)
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
	print(current_matches)
	find_bombs()
	current_matches.clear()
	print("destroy_matched")
	for i in width:
		for j in height:
			if all_pieces[i][j] !=null:
				if all_pieces[i][j].matched:
					all_pieces[i][j].queue_free()
					all_pieces[i][j] = null
					emit_signal("update_score",piece_value*streak)
	$collapse_timer.start()

func collapse_columns():
	print("collapse_columns")
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
	print("refill_columns")
	streak+=1
	for i in width:
		for j in height:
			if all_pieces[i][j] == null and not restricted_movement(Vector2(i,j)):
				spawn_one_piece(i,j,false)
	after_refill()

func after_refill():
	print("after_refill")
	var foundMatched = find_matches()
	if not foundMatched:
		state = move
	streak = 1

func _on_destroy_timer_timeout():
	destroy_matched()


func _on_collapse_timer_timeout():
	collapse_columns()


func _on_refill_timer_timeout():
	refill_columns()
