extends Node2D


var kicked
var window_size:Vector2
var scene_load = preload("res://scenes/stuff/globular_orb.tscn")
var level:int = 0
var level_instance
@export var time:int = 30
var available_levels:int = 4

func _ready():
	window_size = get_viewport_rect().size
	$Tiptext.position = window_size/2
	$Tiptext.scale = window_size / $Tiptext.texture.get_size()

func _process(_delta):
	if not kicked and Input.is_action_pressed("kick"):
		level += 2
		load_level()
		kicked = true
		$Tiptext.visible = false
		$Individual/AnimatedSprite2D.self_modulate = Color(0,0,0,1)
		$Individual/KickDetector/AnimatedSprite2D.visible = true

func _on_individual_damage_taken(health):
	if health <= 0:
		player_transition()
		level_instance.queue_free()
		await get_tree().create_timer(5).timeout
		get_tree().quit()

func switch_level():
	level += 1
	var tween = get_tree().create_tween()
	player_transition()
	level_instance.queue_free()
	tween.tween_property($Individual,"position",window_size/2,1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	if available_levels >= level:
		load_level()
		$Individual/AnimatedSprite2D.self_modulate = Color(0,0,0,1)
		$Individual/KickDetector/AnimatedSprite2D.visible = true
		await get_tree().create_timer(.5).timeout
		$Individual.disable_controls = false
	else:
		tween = get_tree().create_tween()
		var tween2 = get_tree().create_tween()
		tween2.tween_property($ColorRect,"color",Color(1,1,1,1),6).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property($Individual/AnimatedSprite2D,"self_modulate",Color(0.5,0.5,0.5,1),3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property($Individual/AnimatedSprite2D,"self_modulate",Color(1,1,1,1),3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		await get_tree().create_timer(10).timeout
		get_tree().quit()

func load_level():
	var level_path = "res://scenes/levels/level_"+str(level)+".tscn"
	var level_packed = load(level_path)
	level_instance = level_packed.instantiate()
	level_instance.window_size = window_size
	level_instance.player = $Individual
	level_instance.player_health = $Individual.health
	add_child(level_instance)
	$Individual.damage_taken.connect(level_instance._on_damage_taken)
	
func player_transition():
	$Individual.disable_controls = true
	$Individual/AnimatedSprite2D.self_modulate = Color(1,1,1,1)
	$Individual/KickDetector/AnimatedSprite2D.visible = false

#   more like glizzhub
