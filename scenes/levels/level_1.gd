extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")

@export var box_region_start: Node2D
@export var box_region_end: Node2D
@onready var box1 = preload("res://scenes/object.tscn")

@onready var diff : int 
@onready var levelTrack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levelTrack = 1
	diff = 0
	randomize()
	generate_objects()
	generate_mobs()
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
		
func is_colidingPLAYER(area: Area2D):
	var body = get_tree().get_nodes_in_group("Player")
	for i in body:
		if(area.overlaps_area(i)):
			return true
		return false

func is_level_clear():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	return enemies.is_empty()
	
#func _on_mob_spawn_timeout() -> void:
#	var mob = enemy.instantiate()
#	add_child(mob)
#	mob.target_to_chase  = $Player

func generate_mobs():
	var count = levelTrack*2+(int)(diff/100)
	var region_start_node = box_region_start
	var region_end_node = box_region_end
	while(count>0):
		var x = randi_range(region_start_node.position.x, region_end_node.position.x)
		var y = randi_range(region_start_node.position.y, region_end_node.position.y)
		var mob = enemy.instantiate()
		mob.position = Vector2(x, y)
		mob.target_to_chase = $Player
		if(!is_colidingPLAYER(mob.get_node("Area2D"))):
			add_child(mob)
			count -= 1
		else:
			mob.queue_free()
	

func generate_objects():
		var region_start_node = box_region_start
		var region_end_node = box_region_end
		var object_resource = box1
		var count = randi()%2 + 2
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

func nextLevel():
	levelTrack += 1
	updateDiff(50, 1)

func updateDiff(value:int, add:bool):
	diff += value

func outOfControl():
	pass


func _on_diff_timeout() -> void:
	updateDiff(1, 1)
