extends Label

@export var messages = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_message_timers(delta)
	display_messages()

func display_messages():
	text = ""
	for message in messages:
		text += message[0] + "\n"

func update_message_timers(delta):
	for message in messages:
		message[1] += delta
		if message[1] > message[2]:
			messages.erase(message)

func add_message(message: String, timeout):
	messages.append([message, 0, timeout])
