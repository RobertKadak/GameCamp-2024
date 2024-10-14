extends CharacterBody2D

@onready var boss_projectile = preload("res://characters/boss/boss_projectile.tscn")
@onready var world = get_parent()
@export var target: Node2D
@export var target2: Node2D
@export var source: Node2D
@export var health = 5 

func _ready() -> void:
	$Timer.start()
	$AnimatedSprite2D.play()
	position = Vector2(428, 14)

func _process(delta: float) -> void:
	pass

func send_projectile(source, target):
	var projectile = boss_projectile.instantiate()
	world.add_child(projectile)
	
	var position_to_source = target - source
	projectile.global_position = global_position
	projectile.direction = position_to_source.normalized()


func _on_timer_timeout() -> void:
	send_projectile(source.global_position, Vector2(target.global_position.x, randi_range(target.global_position.y, target2.global_position.y)))
	$Timer.start()

func receive_damage(hp):
	health -= hp
	if health <= 0:
		queue_free()
