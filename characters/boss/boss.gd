extends CharacterBody2D

@onready var boss_projectile = preload("res://characters/boss/boss_projectile.tscn")
@onready var world = get_parent()

func _process(delta: float) -> void:
	pass

func send_projectile(source, target):
	var projectile = boss_projectile.instantiate()
	world.add_child(projectile)
	
	var position_to_mouse = target - 
	projectile.global_position = global_position
	projectile.direction = position_to_mouse.normalized()
