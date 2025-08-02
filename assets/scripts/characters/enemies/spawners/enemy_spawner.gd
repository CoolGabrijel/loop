extends Node3D
class_name EnemySpawner

const CHASER_ENEMY = preload("res://scenes/characters/enemies/chaser/chaser_enemy.tscn")

@export var patrol_waypoints : Node3D

func _ready() -> void:
	#spawn_enemy()
	pass

func spawn_enemy() -> void:
	var enemy: chaser_enemy = CHASER_ENEMY.instantiate()
	enemy.patrol_points = patrol_waypoints.get_path()
	enemy.player_ref = Player.player
	add_child(enemy)
