extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func is_level_clear():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	return len(enemies) == 0


func _on_mob_spawn_timeout() -> void:
	var mob = enemy.instantiate()
	add_child(mob)
	mob.target_to_chase  = $Player
