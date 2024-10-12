extends CharacterBody2D # Might need to be changed


@export var speed = 400
@export var health = 100
@export var melee_attack_range = 200

@onready var _animated_sprite = $WalkingAnimatedSprite2D
@onready var _melee = $Melee


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_melee.get_node("MeleeAnimatedSprite2D").stop()
	_melee.get_node("MeleeAnimatedSprite2D").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	melee_animations(velocity)
	movement_animations(velocity)
	movement(velocity, delta)

func melee_animations(velocity: Vector2) -> void:
	if not velocity.is_zero_approx():
		var melee_attack_position = velocity.normalized() * melee_attack_range
		_melee.position = melee_attack_position
	
	if Input.is_action_just_pressed("attack_melee"):
		_melee.get_node("MeleeAnimatedSprite2D").show()
		_melee.get_node("MeleeAnimatedSprite2D").play("melee")
	else:
		if _melee.get_node("MeleeAnimatedSprite2D").frame == 2:
			_melee.get_node("MeleeAnimatedSprite2D").stop()
			_melee.get_node("MeleeAnimatedSprite2D").hide()

func movement_animations(velocity: Vector2) -> void:
	if velocity.x != 0:
		_animated_sprite.flip_h = velocity.x > 0
	
	if velocity.is_zero_approx():
		_animated_sprite.stop()
	else:
		_animated_sprite.play("walk")

func movement(velocity: Vector2, delta: float) -> void:
	move_and_collide(velocity * speed * delta)
