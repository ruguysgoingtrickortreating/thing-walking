extends "res://scenes/stuff/globular_orb.gd"

func explode():
	var tween = get_tree().create_tween()
	standard_explode()
	$Laser.add_point(position.direction_to(player.position)*9999)
	tween.tween_property($Laser,"default_color",Color(1,1,1,1),0.8)
	$AnimatedSprite2D.look_at(player.position)
	
	await tween.finished
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer2.play()
	
	$Laser.width = 40
	$Laser/LaserDetector/CollisionShape2D.shape.b = $Laser.points[1]
	$Laser/LaserDetector.monitoring = true
	
	tween.tween_property($Laser,"width",0,1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Laser,"default_color",Color(1,1,1,0),1.5)
	
	await get_tree().create_timer(.1).timeout
	if $Laser/LaserDetector: $Laser/LaserDetector.queue_free()
	await tween.finished
	queue_free()


func _on_laser_detector_body_entered(body):
	if body == player:
		body.take_damage()
		$Laser.queue_free()
		
