extends Node2D

class_name Stopwatch

@export var time = 0.0

func _process(delta):
	time += delta
