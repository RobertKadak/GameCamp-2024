extends Timer
@onready var timer: Timer = $Timer

var time = 0.0
var stopped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stopped:
		return
	time += delta

func reset():
	time = 0.0

func timeToString():
	var sec  = fmod(time, 60)
	var min = time/60
	var format_string = "%02d : 02d%"
	var actual_string = format_string % [min, sec]
