extends Area2D

@onready var level = get_parent()

func _process(delta: float) -> void:
	if monitoring == false and level.is_level_clear():
		monitoring = true

func _on_body_entered(body: Node2D) -> void:
	if (level.levelTrack == 3):
		pass
	if body.is_in_group("Player"):
		monitoring = false
		level.get_node("Player").global_position = Vector2.ZERO
		level.clear()
		level.generate_objects()
		level.nextLevel()
		pass # level funtion to clear, regenerate level and teleport player
