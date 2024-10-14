extends Area2D

@export var enemy_type = 0
@export var health = 7
@export var spawn_rate = 3
@export var spawn_on_broken = 3

@onready var enemy0 = preload("res://scenes/enemy.tscn")
@onready var enemy1 = preload("res://scenes/para_enemy.tscn")
@onready var broken = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HalfSprite.hide()
	$Timer.wait_time = spawn_rate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func do_damage(hp):
	if broken:
		health -= hp
		if health <= 0:
			queue_free()
	else:
		$HalfSprite.show()
		$FullSprite.hide()
