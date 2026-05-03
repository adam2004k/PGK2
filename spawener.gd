extends Node3D

@onready var markers = $Markers.get_children()
var enemy_scene = preload("res://enemy.tscn")

func _ready():
	randomize()
	spawn_enemies()

func spawn_enemies():
	var ile = randi_range(10, 40)
	print("Ilość do zrespienia:", ile)
	for i in range(ile):
		var enemy = enemy_scene.instantiate()

		var marker = markers.pick_random()

		var offset = Vector3(
			randi_range(-2, 2),
			0,
			randi_range(-2, 2)
		)

		enemy.position = marker.global_position + offset
		
		get_tree().current_scene.add_child.call_deferred(enemy)
		print("Spawn enemy nr:", i + 1)
