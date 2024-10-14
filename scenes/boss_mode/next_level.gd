extends Area2D

func _process(delta: float) -> void:
	monitoring = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if(is_level_clear()):
			get_tree().change_scene_to_file("res://scenes/cut_scene.tscn")

func is_level_clear():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var enemy_spawners = get_tree().get_nodes_in_group("EnemySpawner")
	return enemies.is_empty() and enemy_spawners.is_empty()
