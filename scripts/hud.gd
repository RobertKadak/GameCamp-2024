extends Node2D

@export var Stopwatch_label : Label

var Stopwatch : Stopwatch
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Stopwatch = get_tree().get_first_node_in_group("StopWatch")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_Stopwatch_label
	
	
	
func update_Stopwatch_label():
	Stopwatch_label.text = Stopwatch.time_to_string()
	
