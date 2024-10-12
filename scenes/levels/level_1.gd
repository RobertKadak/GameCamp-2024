extends Node2D

var elapsedTime : int
var diffInd : int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_level_clear():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	return len(enemies) == 0
