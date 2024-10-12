extends CharacterBody2D # Might need to be changed


@export var speed = 400
@export var health = 100
@export var melee_attack_range = 200
@export var charging_ranged_attack = false
@export var charging_ranged_timer = 0
@export var charging_ranged_timer_required = 5

@export var melee_timeout = .7
@export var melee_timeout_counter = 100

@onready var _animated_sprite = $WalkingAnimatedSprite2D
@onready var _melee = $Melee
@onready var ranged_projectile = preload("res://characters/player/ranged/projectile.tscn")
@onready var world = get_parent()

var i_hate_godot = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("walk")
	_melee.get_node("MeleeAnimatedSprite2D").stop()
	_melee.get_node("MeleeAnimatedSprite2D").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	melee_timeout_counter += delta
	
	if not charging_ranged_attack:
		melee_animations(velocity)
		movement_animations(velocity)
		movement(velocity, delta)
		charge_ranged()
	else:
		discharge_ranged(delta)

func charge_ranged():
	if Input.is_action_just_pressed("attack_ranged") and melee_timeout_counter > melee_timeout:
		charging_ranged_attack = true
		charging_ranged_timer = 0
		_animated_sprite.play("ranged")

func discharge_ranged(delta: float):
	charging_ranged_timer += delta
	if Input.is_action_just_released("attack_ranged"):
		if charging_ranged_timer > charging_ranged_timer_required:
			var projectile = ranged_projectile.instantiate()
			world.add_child(projectile)
			
			var position_to_mouse = get_global_mouse_position() - global_position
			projectile.global_position = global_position
			projectile.direction = position_to_mouse.normalized()
		else:
			pass # Attack failed
		_animated_sprite.stop()
		charging_ranged_attack = false
		_animated_sprite.play("walk")
		charging_ranged_timer = 0

func melee_animations(velocity: Vector2) -> void:
	var position_to_mouse = get_global_mouse_position() - global_position
	
	var melee_attack_vector = position_to_mouse.normalized() * melee_attack_range
	_melee.global_position = global_position + melee_attack_vector
	
	if Input.is_action_just_pressed("attack_melee") and melee_timeout_counter > melee_timeout:
		melee_timeout_counter = 0
		
		for body in _melee.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				body.receive_damage(1)
		
		i_hate_godot = 0
		_animated_sprite.play("melee")
		_melee.get_node("MeleeAnimatedSprite2D").show()
		_melee.get_node("MeleeAnimatedSprite2D").play("melee")
	else:
		if _melee.get_node("MeleeAnimatedSprite2D").frame == 2:
			_melee.get_node("MeleeAnimatedSprite2D").stop()
			_melee.get_node("MeleeAnimatedSprite2D").hide()
		
		if i_hate_godot == 1 and _animated_sprite.frame == 0:
			_animated_sprite.play("walk")
		
		
		if _animated_sprite.animation == "melee":
			i_hate_godot = _animated_sprite.frame

func movement_animations(velocity: Vector2) -> void:
	if velocity.x != 0:
		_animated_sprite.flip_h = velocity.x > 0
	
	if _animated_sprite.animation != "melee":
		if velocity.is_zero_approx():
			_animated_sprite.stop()
		else:
			_animated_sprite.play("walk")

func movement(velocity: Vector2, delta: float) -> void:
	move_and_collide(velocity * speed * delta)
