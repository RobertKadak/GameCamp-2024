extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D
@export var health = 5 
@export var attacking = false
@export var since_last_attack = 0
@export var attack_timeout = 3
@export var damage = 1

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var since_last_flip = 0
@onready var tmptime = 0

@export var speed = 180.0

@export var freq = 10
@export var size = 70

func _ready() -> void:
	$AnimatedSprite2D.play("walk")

func _physics_process(_delta: float) -> void:
	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position() + Vector2(0, sin(tmptime * freq) * size)) * speed
	#velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed
	
	if since_last_flip > .1:
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x > 0
			since_last_flip = 0
	
	move_and_slide()

func _process(delta: float) -> void:
	since_last_flip += delta
	since_last_attack += delta
	tmptime += delta
	
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == 2:
		$AnimatedSprite2D.play("walk")
	
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("Player"):
			if since_last_attack > attack_timeout:
				attack()
				since_last_attack = 0
	
func attack():
	$AnimatedSprite2D.play("attack")
	player.health -= damage

func receive_damage(hp):
	health -= hp
	
	if health <= 0:
		queue_free()
