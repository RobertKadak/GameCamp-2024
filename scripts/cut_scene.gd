extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/boss_mode/level_1.tscn")
