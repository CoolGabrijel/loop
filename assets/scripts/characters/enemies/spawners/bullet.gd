extends Area3D
class_name Bullet

@onready var life_timer: Timer = $LifeTimer

# Bullet movement direction and speed
var _direction: Vector3 = Vector3(50, -50, -50)

var life_time: float = 10.0
var _damage: int = 0

func _ready() -> void:
	life_timer.wait_time = life_time
	life_timer.start()

func _process(delta: float) -> void:
	position += _direction * delta

func setup(start_position: Vector3, direction: Vector3, speed: float, damage: int) -> void:
	var adjusted_direction = direction.normalized()
	
	# Reduce vertical drop
	adjusted_direction.y *= 0.1 
	
	# Set direction and speed
	_direction = adjusted_direction.normalized() * speed
	
	# Set starting position
	global_position = start_position
	
	# Setup bullet damage
	_damage = damage

func _on_body_entered(body: Node3D) -> void:
	# Destroy bullet on collision
	if body is Player:
		body.health_node.damage(_damage)
		queue_free()

func _on_life_timer_timeout() -> void:
	# Destroy bullet after period of time
	queue_free()
