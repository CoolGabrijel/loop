extends Node3D
class_name EnemySpawner

const CHASER_ENEMY = preload("res://scenes/characters/enemies/chaser/chaser_enemy.tscn")

func _ready() -> void:
	pass

func spawn_enemy() -> void:
	var enemy := CHASER_ENEMY.instantiate()
	add_child(enemy)
