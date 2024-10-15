extends CharacterBody2D

@onready var boss_projectile = preload("res://characters/boss/boss_projectile.tscn")
@onready var world = get_parent()
@onready var time = 0
@export var target: Node2D
@export var target2: Node2D
@export var target3: Node2D
@export var target4: Node2D
@export var source: Node2D
@export var source2: Node2D
@export var health = 5

@onready var hand = true

func _ready() -> void:
	$Timer.start()
	$Timer2.wait_time = 12.3
	$Timer2.start()
	$AnimatedSprite2D.play()

func _process(delta: float) -> void:
	time += delta
	position += Vector2(0, cos(time * 1.5) / 1.5)

func send_projectile(source, target):
	var projectile = boss_projectile.instantiate()
	world.add_child(projectile)
	
	var position_to_source = target - source
	projectile.global_position = source
	projectile.direction = position_to_source.normalized()
	projectile.dir()


func _on_timer_timeout() -> void:
	if hand:
		send_projectile(source2.global_position, Vector2(randi_range(target.global_position.x, target2.global_position.x), randi_range(target.global_position.y, target2.global_position.y)))
	else:
		send_projectile(source.global_position, Vector2(randi_range(target3.global_position.x, target4.global_position.x), randi_range(target3.global_position.y, target4.global_position.y)))
	$Timer.wait_time = 1 + sin(time / 2)
	$Timer.start()

func receive_damage(hp):
	health -= hp
	if health <= 0:
		queue_free()


func _on_timer_2_timeout() -> void:
	hand = !hand
	$Timer2.start()
