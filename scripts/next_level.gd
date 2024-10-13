extends Area2D


@onready var level = get_parent()
@onready var boss = preload("res://characters/boss.tscn")

func _process(delta: float) -> void:
	monitoring = true
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if(level.is_level_clear()):
			level.get_node("Player").global_position = Vector2.ZERO
			level.clear()
			level.generate_objects()
			level.generate_mobs()
			level.nextLevel()
		pass # level funtion to clear, regenerate level and teleport player
