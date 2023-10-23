extends Area2D

var facing:Vector2
var speed = 150

func _process(delta):
	position += facing * speed * delta

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		body.take_damage()
		queue_free()
