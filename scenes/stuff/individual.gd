extends CharacterBody2D

signal damage_taken
signal switch_level

@export var speed:int = 50000
@export var health:int = 3
var kicking:bool = false
var disable_controls:bool = false
var window_size:Vector2

func _ready():
	window_size = get_viewport_rect().size

func _physics_process(delta):
	
	if kicking or disable_controls:
		return
	
	if Input.is_action_just_pressed("kick"):
		var KickList:Array[Area2D] = $KickDetector.get_overlapping_areas()
		for i in KickList:
			if i.is_in_group("enemies"):
				i.explode()
			if i.is_in_group("level_switch"):
				emit_signal("switch_level")
		$AnimatedSprite2D.play("kick")
		$KickDetector/AnimatedSprite2D.play("active")
		kicking = true
		$KickTimer.start()
		return
	
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed * delta
	if velocity:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$KickDetector.position = direction * 125
		position = position.clamp(Vector2.ZERO,window_size)
	else:
		$AnimatedSprite2D.play("idle")
	move_and_slide()

func _on_kick_timer_timeout():
	kicking = false
	$KickDetector/AnimatedSprite2D.play("default")

func take_damage(amnt:int = 1):
	health -= amnt
	emit_signal("damage_taken", health)
	if health <= 0:
		$AnimatedSprite2D.play("explode")
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer2.play()
