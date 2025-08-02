extends Node3D
class_name Room

@export var connection_points: Array[RoomConnection]
@export var enemy_spawners: Array[EnemySpawner]

func spawn_enemies() -> void:
	if enemy_spawners.is_empty():
		return
	
	var enemy_amount := randi_range(1, enemy_spawners.size())
	
	for i in enemy_amount:
		var spawner := enemy_spawners[randi_range(0, enemy_spawners.size()-1)]
		enemy_spawners.erase(spawner)
		spawner.spawn_enemy()
