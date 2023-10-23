extends Node

@export var enemy_types:Array[PackedScene]
@export var time:int = 10

var window_size:Vector2
var player
var player_health:int

var enemy_count:int

func _ready():
	$UI/HealthSprite.play(str(player_health))
	$UI/TimeLabel.text = "%02d" % time
	$AudioStreamPlayer.play()

func _on_enemy_timer_timeout():
	enemy_count = (enemy_count + 1) % enemy_types.size()
	
	var spawn_location:Vector2 = Vector2.ZERO
	if randf() < 0.5:
		spawn_location.x = randf() * window_size.x
		spawn_location.y = randi_range(0,1) * window_size.y
	else:
		spawn_location.y = randf() * window_size.y
		spawn_location.x = randi_range(0,1) * window_size.x
	
	var instance = enemy_types[enemy_count].instantiate()
	add_child(instance)
	instance.get_node("AnimatedSprite2D").play("default")
	instance.position = spawn_location
	instance.player = player

func _on_music_loop_timer_timeout():
	$AudioStreamPlayer.play()

func _on_time_timer_timeout():
	time -= 1
	$UI/TimeLabel.text = "%02d" % time
	if time == 1:
		$EnemyTimer.stop()
	if time < 1:
		$UI/TimeLabel.visible = false
		$UI/TimeSprite/Continue.visible = true
		$UI/Area2D.monitorable = true
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.explode()

func _on_damage_taken(health):
	$UI/HealthSprite.play(str(health))
