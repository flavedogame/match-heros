# Base entity that represents a character or a monster in combat
# Every battler has an AI node so all characters can work as a monster
# or as a computer-controlled player ally
extends Position2D

class_name Battler

export var stats: Resource
export var career: Resource

onready var skin = $Skin
onready var bars = $Bars

onready var emotes = $emotes

var is_alive = true

export var attack_move_time = 0.5

var color_related

var display_name: String
var id_name:String

export var party_member = false

var target_global_position: Vector2
export var TARGET_OFFSET_DISTANCE: float = 120.0

var _anim
var _stats
var _career

# Called when the node enters the scene tree for the first time.
func _ready():
	var direction: Vector2 = Vector2(1.0, 0.0) if party_member else Vector2(-1.0, 0.0)
	target_global_position = $TargetAnchor.global_position + direction * TARGET_OFFSET_DISTANCE
	
	skin.add_child(_anim)
	stats = _stats
	career = _career
	initialize()
	
	Events.connect("actor_talking",self,"on_actor_talking")
	Events.connect("finish_dialog",self,"on_finish_dialog")

func on_actor_talking(actor_name):
	if id_name == actor_name:
		emotes.start_talking()
	else:
		emotes.stop_talking()

func on_finish_dialog(id):
	emotes.stop_talking()
	

func init(info, is_party_member):
	party_member = is_party_member
	#"res://Scenes/battler/"+info.anim+".tscn"
	#res://Scenes/battler/HeressAnim.tscn
	_anim = load("res://Scenes/battler/"+info.anim+".tscn").instance()
	_anim.init(is_party_member)
	_stats = load("res://resources/battler/"+info.stats+".tres").copy()
	
	if is_party_member:
		_career = load("res://resources/battler/"+info.career+".tres").copy()
	id_name = info.get("id_name","")

func initialize():
	skin.initialize()
	#stats = stats.copy()
	stats.connect("health_depleted", self, "_on_health_depleted")
	emotes.stop_talking()

func is_able_to_play() -> bool:
	# Returns true if the battler can perform an action
	return stats.health > 0

func take_damage(hit):
	stats.take_damage(hit)
	# prevent playing both stagger and death animation if health <= 0
	if stats.health > 0:
		skin.play_stagger()

func _on_health_depleted():
	is_alive = false
	yield(skin.play_death(), "completed")
	emit_signal("died", self)

func attack(target, move_details):
	var attack_value = 1
	if move_details:
		#orange
		
		color_related =  career.color_related
		attack_value = move_details.get(color_related,0)
		if attack_value == 0:
			yield(get_tree(), "idle_frame")
			return
	print(color_related)
	var hit = Hit.new(stats.strength * attack_value)
	yield(skin.move_to(target), "completed")
	target.take_damage(hit)
	yield(get_tree().create_timer(attack_move_time), "timeout")
	yield(skin.return_to_start(), "completed")
	
