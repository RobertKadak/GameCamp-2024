extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")

@export var box_region_start: Node2D
@export var box_region_end: Node2D
@export var box_region_start2: Node2D
@export var box_region_end2: Node2D
@onready var box1 = preload("res://scenes/object.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_objects(box_region_start, box_region_end, box1)
	generate_objects(box_region_start2, box_region_end2, box1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_level_clear():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	return len(enemies) == 0

func _on_mob_spawn_timeout() -> void:
	var mob = enemy.instantiate()
	add_child(mob)
	mob.target_to_chase  = $Player

func generate_objects(region_start_node: Node2D, region_end_node: Node2D,
		object_resource: Resource, count=1):
	while count != 0:
		var x = randi_range(region_start_node.position.x, region_end_node.position.x)
		var y = randi_range(region_start_node.position.y, region_end_node.position.y)
		
		var object = object_resource.instantiate()
		object.position = Vector2(x, y)
		add_child(object)
		
		# Might add some constriction checks
		count -= 1

func clear():
	var clearables = get_tree().get_nodes_in_group("Objects")
	for i in clearables:
		i.queue_free()

func regen():
	pass
