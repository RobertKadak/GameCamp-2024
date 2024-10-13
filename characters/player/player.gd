extends CharacterBody2D # Might need to be changed


@export var speed = 400
@export var health = 100
@export var melee_attack_range = 200
@export var charging_ranged_attack = false
@export var charging_ranged_timer = 0
@export var charging_ranged_timer_required = 5

@export var is_vertical_switched = false
@export var is_horizontal_switched = false

@export var melee_timeout = .7
@export var melee_timeout_counter = 0

@export var ranged_timeout = 3
@export var ranged_timeout_counter = 0

@export var dash_distance = .08
@export var dash_speed = 8
@export var dash_timeout = 5
@export var dash_timeout_timer = 0
@export var speed_multi = 1

@onready var _animated_sprite = $WalkingAnimatedSprite2D
@onready var _melee = $Melee
@onready var _collision_shape_2D = $CollisionShape2D
@onready var ranged_projectile = preload("res://characters/player/ranged/projectile.tscn")
@onready var world = get_parent()

@onready var degen = ""
@onready var degen_change_interval = 60
@onready var degen_change_timer = 0
@onready var notification_manager = get_tree().get_first_node_in_group("NotificationManager")
@onready var noti1 = false
@onready var noti2 = false

func apply_degen():
	if degen_change_timer > degen_change_interval * 2:
		degen = "2"
		if not noti2:
			notification_manager.add_message("You have deteriorated into a stage two cat-girl mutant", 4)
			noti2 = true
	elif degen_change_timer > degen_change_interval:
		degen = "1"
		if not noti1:
			notification_manager.add_message("You have deteriorated into a stage one cat-girl mutant", 4)
			noti1 = true

var i_hate_godot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("walk" + degen)
	_melee.get_node("MeleeAnimatedSprite2D").stop()
	_melee.get_node("MeleeAnimatedSprite2D").hide()
	
	melee_timeout_counter = melee_timeout
	dash_timeout_timer = dash_timeout
	ranged_timeout_counter = ranged_timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		get_tree().change_scene_to_file("res://assets/losescreen.png")
		
	var move_left = "move_left"
	var move_right = "move_right"
	var move_up = "move_up"
	var move_down = "move_down"
	if is_horizontal_switched:
		move_left = "move_right"
		move_right = "move_left"
	if is_vertical_switched:
		move_up = "move_down"
		move_down = "move_up"
		
	var velocity = Input.get_vector(move_left, move_right, move_up, move_down)
	
	melee_timeout_counter += delta
	dash_timeout_timer += delta
	degen_change_timer += delta
	ranged_timeout_counter += delta
	
	if not charging_ranged_attack:
		melee_animations(velocity)
		movement_animations(velocity)
		movement(velocity, delta)
		dash_movement(velocity)
		charge_ranged()
	else:
		discharge_ranged(delta)
	
	if charging_ranged_timer > charging_ranged_timer_required and Input.is_action_pressed("attack_ranged"):
		_animated_sprite.play("ranged_ready" + degen)
	
	apply_degen()

func dash_movement(velocity: Vector2):
	if dash_timeout_timer > dash_distance:
		speed_multi = 1
		if _collision_shape_2D.disabled:
			_collision_shape_2D.disabled = false
	
	if Input.is_action_just_pressed("move_dash"):
		if dash_timeout < dash_timeout_timer:
			_collision_shape_2D.disabled = true
			speed_multi = dash_speed
			dash_timeout_timer = 0

func charge_ranged():
	if Input.is_action_just_pressed("attack_ranged") and melee_timeout_counter > melee_timeout and ranged_timeout_counter > ranged_timeout:
		charging_ranged_attack = true
		charging_ranged_timer = 0
		_animated_sprite.play("ranged" + degen)
		_melee.get_node("MeleeAnimatedSprite2D").hide()

func discharge_ranged(delta: float):
	charging_ranged_timer += delta
	if Input.is_action_just_released("attack_ranged"):
		if charging_ranged_timer > charging_ranged_timer_required:
			var projectile = ranged_projectile.instantiate()
			world.add_child(projectile)
			
			var position_to_mouse = get_global_mouse_position() - global_position
			projectile.global_position = global_position
			projectile.direction = position_to_mouse.normalized()
				
			ranged_timeout_counter = 0
			melee_timeout_counter = 0
		else:
			pass
		_animated_sprite.stop()
		charging_ranged_attack = false
		_animated_sprite.play("walk" + degen)
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
		_animated_sprite.play("melee" + degen)
		_melee.get_node("MeleeAnimatedSprite2D").show()
		_melee.get_node("MeleeAnimatedSprite2D").frame = 0
		_melee.get_node("MeleeAnimatedSprite2D").play("melee" + degen)
		
		$Timer.start()
	else:
		if i_hate_godot == 1 and _animated_sprite.frame == 0 and _animated_sprite.animation == "melee":
			_animated_sprite.play("walk" + degen)
		
		if _animated_sprite.animation == "melee":
			i_hate_godot = _animated_sprite.frame

func movement_animations(velocity: Vector2) -> void:
	if velocity.x != 0:
		_animated_sprite.flip_h = velocity.x > 0
	
	if _animated_sprite.animation != "melee":
		if velocity.is_zero_approx():
			if _animated_sprite.animation != "idle":
				_animated_sprite.play("idle" + degen)
		else:
			_animated_sprite.play("walk" + degen)

func movement(velocity: Vector2, delta: float) -> void:
	move_and_collide(velocity * speed * delta * speed_multi)


func _on_timer_timeout() -> void:
	_melee.get_node("MeleeAnimatedSprite2D").stop()
	_melee.get_node("MeleeAnimatedSprite2D").hide()
	_melee.get_node("MeleeAnimatedSprite2D").frame = 0
	$Timer.stop()
