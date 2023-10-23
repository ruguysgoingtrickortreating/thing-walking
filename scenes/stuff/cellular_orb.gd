extends "res://scenes/stuff/globular_orb.gd"

var glob:PackedScene = load("res://scenes/stuff/cellular_glob.tscn")

func explode():
	standard_explode()
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("nothing")
	for i in 4:
		var instance = glob.instantiate()
		var facing = Vector2(cos((i) * PI/2), sin((i) * PI/2))
		instance.position = position + facing * 20
		instance.facing = facing
		instance.get_node("AnimatedSprite2D").play("default")
		add_sibling(instance)
	await $AudioStreamPlayer.finished
	queue_free()
