extends Area2D

@export var speed:int
var player:CharacterBody2D
var dying



func _process(delta):
	if dying: return
	
	var direction:Vector2 = position.direction_to(player.position)
	position += direction * speed * delta
	

func explode():
	standard_explode()
	await $AudioStreamPlayer.finished
	queue_free()

func standard_explode():
	dying = true
	monitorable = false
	monitoring = false
	$AnimatedSprite2D.play("explode")
	$AudioStreamPlayer.pitch_scale += randf_range(-0.25,0.25)
	$AudioStreamPlayer.play()
	

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		body.take_damage()
		queue_free()
