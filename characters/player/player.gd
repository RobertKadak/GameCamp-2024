extends CharacterBody2D # Might need to be changed


@export var speed = 400
@export var health = 100
@export var melee_attack_range = 200
@export var charging_ranged_attack = false
@export var charging_ranged_timer = 0
@export var charging_ranged_timer_required = 5

@onready var _animated_sprite = $WalkingAnimatedSprite2D
@onready var _melee = $Melee


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_melee.get_node("MeleeAnimatedSprite2D").stop()
	_melee.get_node("MeleeAnimatedSprite2D").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if not charging_ranged_attack:
		melee_animations(velocity)
		movement_animations(velocity)
		movement(velocity, delta)
		charge_ranged()
	else:
		discharge_ranged(delta)	
	
	print(delta)

func charge_ranged():
	if Input.is_action_just_pressed("attack_ranged"):
		charging_ranged_attack = true
		charging_ranged_timer = 0
		_animated_sprite.play("ranged")

func discharge_ranged(delta: float):
	charging_ranged_timer += delta
	if Input.is_action_just_released("attack_ranged"):
		if charging_ranged_timer > charging_ranged_timer_required:
			pass # Do the attack
		else:
			pass # Attack failed
		_animated_sprite.stop()
		charging_ranged_attack = false
		_animated_sprite.play("walk")

func melee_animations(velocity: Vector2) -> void:
	var position_to_mouse = get_global_mouse_position() - global_position
	
	var melee_attack_position = position_to_mouse.normalized() * melee_attack_range
	_melee.position = melee_attack_position
	
	if Input.is_action_just_pressed("attack_melee"):
		for body in _melee.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				body.receive_damage(1)
		
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
