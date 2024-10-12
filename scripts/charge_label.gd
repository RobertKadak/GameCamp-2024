extends Label

@onready var player = get_node("/root/level1/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = ""
	if player.charging_ranged_timer > player.charging_ranged_timer_required:
		text = "Furrball ready"
