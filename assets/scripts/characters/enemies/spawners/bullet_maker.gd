extends Node

@export var bullet_scene: PackedScene

func _enter_tree() -> void:
	SignalHub.on_create_bullet.connect(on_create_bullet)

func on_create_bullet(start_position: Vector3, direction: Vector3, speed: float, damage: int) -> void:
	var new_bullet: Bullet = bullet_scene.instantiate()
	new_bullet.name = "Bullet@"
	
	call_deferred("add_child", new_bullet, true)
	
	new_bullet.call_deferred("setup", start_position, direction, speed, damage)

	
	
