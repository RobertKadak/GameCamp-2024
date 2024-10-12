extends Area2D

@export var health : Health

func takeDamage(attack: Attack):
	if health:
		health.takeDamage(attack)
	
