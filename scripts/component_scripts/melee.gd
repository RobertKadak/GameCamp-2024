extends Node2D

var attackDmg = 100

func _on_hitbox_area_entered(area):
	if area.has_method("takeDamage"):
		var attack = Attack.new()
		attack.attackDmg = attackDmg
		area.takeDamage(attack)
