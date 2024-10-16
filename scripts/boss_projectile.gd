extends Area2D


@export var speed = 600
@export var lifetime = 2
@export var lifetime_counter = 0
@export var damage = 0.005
@export var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime_counter += delta
	position += direction * delta * speed
	
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.receive_damage(damage)
	
	if lifetime_counter > lifetime:
		queue_free()
