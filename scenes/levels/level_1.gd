extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")

@export var box_region_start: Node2D
@export var box_region_end: Node2D
@onready var box1 = preload("res://scenes/object.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_objects()
	$NavigationRegion2D.bake_navigation_polygon()

# Called every frame. 'delta' is the elapsed time since the previous frame.a
func _process(delta: float) -> void:
	pass

func is_coliding(area: Area2D):
	var body = get_tree().get_nodes_in_group("Objects")
	for i in body:
		if(area.overlaps_area(i)):
			return true
		return false

func is_level_clear():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	return len(enemies) == 0

func _on_mob_spawn_timeout() -> void:
	var mob = enemy.instantiate()
	add_child(mob)
	mob.target_to_chase  = $Player

func generate_objects():
		var region_start_node = box_region_start
		var region_end_node = box_region_end
		var object_resource = box1
		var count = randi()%3 + 2
		while count > 0:
			var x = randi_range(region_start_node.position.x, region_end_node.position.x)
			var y = randi_range(region_start_node.position.y, region_end_node.position.y)
			
			var object = object_resource.instantiate()
			object.position = Vector2(x, y)
			if(!is_coliding(object.get_node("Area2D"))):
				add_child(object)
				$NavigationRegion2D.add_child(object)
				count -=1
			else:
				object.queue_free()
		# Might add some constriction checks

func clear():
	var clearables = get_tree().get_nodes_in_group("Objects")
	for i in clearables:
		i.queue_free()

func regen():
	pass
