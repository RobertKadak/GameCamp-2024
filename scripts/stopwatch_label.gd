extends Label

@onready var stopwatch = get_node("/root/level1/StopWatch")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var secons = int(stopwatch.time) % 60
	var minutes = int(stopwatch.time / 60)
	text = "%02dM : %02dS" % [minutes, secons]
