extends Area2D

@export var speed = 1100
@export var lifetime = 2
@export var lifetime_counter = 0
@export var damage = 1
@export var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime_counter += delta
	position += direction * delta * speed + Vector2(randi_range(-10, 10), randi_range(-10, 10))
	
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.receive_damage(damage)
	
	if lifetime_counter > lifetime:
		queue_free()
