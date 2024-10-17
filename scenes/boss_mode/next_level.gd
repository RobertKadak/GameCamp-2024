extends Area2D

@onready var notification_manager = get_tree().get_first_node_in_group("NotificationManager")
@export var next_level: PackedScene

func _process(delta: float) -> void:
	monitoring = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if(is_level_clear()):
			get_tree().change_scene_to_packed(next_level)
		else:
			notification_manager.add_message("Clear all enemies and tubes to proceed", 3)

func is_level_clear():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var enemy_spawners = get_tree().get_nodes_in_group("EnemySpawner")
	return enemies.is_empty() and enemy_spawners.is_empty()
