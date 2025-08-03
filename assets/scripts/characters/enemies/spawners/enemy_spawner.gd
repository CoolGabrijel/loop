extends Node3D
class_name EnemySpawner

const CHASER_ENEMY = preload("res://scenes/characters/enemies/chaser/chaser_enemy.tscn")
const GUARD_ENEMY = preload("res://scenes/characters/enemies/guard/guard_enemy.tscn")
const RANGER = preload("res://scenes/characters/enemies/ranger/ranger.tscn")
@export var patrol_waypoints : Node3D

func _ready() -> void:
	#spawn_enemy()
	pass

func spawn_enemy() -> void:
	var enemy
	var rand = randi_range(0,2)
	if rand == 0:
		enemy = CHASER_ENEMY.instantiate()
	elif rand == 1:
		enemy = GUARD_ENEMY.instantiate()
	elif rand == 2:
		enemy = RANGER.instantiate()
	
	enemy.patrol_points = patrol_waypoints.get_path()
	add_child(enemy)
