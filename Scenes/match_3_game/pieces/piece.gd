extends Node2D


export (String) var color
export (Texture) var row_texture
export (Texture) var col_texture
export (Texture) var adj_texture
export (Texture) var color_texture

onready var sprite = $Sprite

var is_row_bomb = false
var is_col_bomb = false
var is_adj_bomb = false
var is_color_bomb = false

var is_bomb_triggered = false

var move_tween
var matched = false

var grid_position = Vector2.INF



# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween = $move_tween

func move(target):
	move_tween.interpolate_property(self,"position",position,target,.3, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	move_tween.start()
	
func make_row_bomb():
	matched = false
	is_row_bomb = true
	$Sprite.texture = row_texture
	$Sprite.modulate = Color(1,1,1,1)
	
func make_col_bomb():
	matched = false
	is_col_bomb = true
	$Sprite.texture = col_texture
	$Sprite.modulate = Color(1,1,1,1)
	
func make_adj_bomb():
	matched = false
	is_adj_bomb = true
	$Sprite.texture = adj_texture
	$Sprite.modulate = Color(1,1,1,1)
	
func make_color_bomb():
	matched = false
	is_color_bomb = true
	$Sprite.texture = color_texture
	$Sprite.modulate = Color(1,1,1,1)
	color = "Color"

func set_matched():
	#$Sprite.modulate = Color(1,1,1,.5)
	matched = true

func set_grid_position(i,j):
	grid_position = Vector2(i,j)
	
func set_disabled(is_disabled):
	if is_disabled:
		$Sprite.modulate = Color(0.5,0.5,0.5,1)
	else:
		$Sprite.modulate = Color(1,1,1,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
