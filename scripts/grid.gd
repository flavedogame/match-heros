extends Node2D

#state machine
enum {wait, move}
var state

export (int) var width = 8
export (int) var height = 8
export (int) var x_start = 64
export (int) var y_start = 900
export (int) var offset = 64
#where the piece should drop from
export (int) var y_offset = -2

var all_pieces = []

var possible_pieces = [
	preload("res://Scenes/yellow_piece.tscn"),
	preload("res://Scenes/blue_piece.tscn"),
	preload("res://Scenes/orange_piece.tscn"),
	preload("res://Scenes/pink_piece.tscn"),
	preload("res://Scenes/green_piece.tscn"),
	preload("res://Scenes/lightgreen_piece.tscn"),
]

#touch variables
var first_touch = Vector2(0,0)
var final_touch = Vector2(0,0)
var controlling = false

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

func spawn_pieces():
	for i in width:
		for j in height:
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
				isMatched = true
				#return true
	if j>1:
		if all_pieces[i][j-1] !=null && all_pieces[i][j-2]!=null:
			if all_pieces[i][j-1].color == color and all_pieces[i][j-2].color == color:
				all_pieces[i][j].call(callback)
				all_pieces[i][j-1].call(callback)
				all_pieces[i][j-2].call(callback)
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
	var first_piece = all_pieces[column][row]
	var final_piece = all_pieces[new_column][new_row]
	if first_piece == null or final_piece == null:
		return
	state = wait
	all_pieces[column][row] = final_piece
	all_pieces[new_column][new_row] = first_piece
	first_piece.move(grid_to_pixel(new_column,new_row))
	final_piece.move(grid_to_pixel(column,row))
	var found_matches = find_matches()
	if not found_matches:
		yield(get_tree().create_timer(0.15), "timeout")
		swap_back(column,row,new_column,new_row)
		
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
		$destroy_timer.start()
	else:
		print("not foundMatched")
		#after_refill()
	return found_matched

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == move:
		touch_input()

func destroy_matched():
	print("destroy_matched")
	for i in width:
		for j in height:
			if all_pieces[i][j] !=null:
				if all_pieces[i][j].matched:
					all_pieces[i][j].queue_free()
					all_pieces[i][j] = null
	$collapse_timer.start()

func collapse_columns():
	print("collapse_columns")
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				for k in range(j+1,height):
					if all_pieces[i][k]!=null:
						all_pieces[i][k].move(grid_to_pixel(i,j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	$refill_timer.start()
						
func refill_columns():
	print("refill_columns")
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				spawn_one_piece(i,j,false)
	after_refill()

func after_refill():
	print("after_refill")
	var foundMatched = find_matches()
	if not foundMatched:
		state = move

func _on_destroy_timer_timeout():
	destroy_matched()


func _on_collapse_timer_timeout():
	collapse_columns()


func _on_refill_timer_timeout():
	refill_columns()
