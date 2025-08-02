extends Node3D
class_name Room

@export var connection_points: Array[RoomConnection]
@export var enemy_spawners: Array[EnemySpawner]
@export var vendor_locations: Array[Node3D]

const vendor_oskar = preload("res://scenes/objects/npcs/vendor_oskar.tscn")

func _ready() -> void:
	spawn_vendor()

func spawn_enemies() -> void:
	if enemy_spawners.is_empty():
		return
	
	var enemy_amount := randi_range(1, enemy_spawners.size())
	
	for i in enemy_amount:
		var spawner := enemy_spawners[randi_range(0, enemy_spawners.size()-1)]
		enemy_spawners.erase(spawner)
		spawner.spawn_enemy()

func spawn_vendor() -> void:
	if vendor_locations.is_empty():
		return
	var vendor: Vendor = vendor_oskar.instantiate()
	var location := vendor_locations[randi_range(0, vendor_locations.size()-1)]
	location.add_child(vendor)
	#vendor.global_position = location.global_position
	
