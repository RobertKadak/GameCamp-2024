extends Node2D
class_name Health

@export var maxHealth := 100
var health : int

func _ready():
	health = maxHealth

func takeDamage(attack: Attack):
	health -= attack.attackDmgsa
	
	if health <= 0:
		get_parent().queue_free()
