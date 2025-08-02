extends Node3D
class_name Damage

@export var attack_damage: int
@export var attack_speed: float
@export var dot_damage: float
@export var vulnerability: int
@export var shield: int

@export var detection_range: float
@export var attack_range: float

@export var is_range_attack: bool
@export var bullet_speed: float

@export var stun_attack_duration: float
# Cooldown of shoot and stun sequence attack, or any other combination
@export var combination_attack_cooldown: float

var enemies_within_range: Array[Node3D]

func _physics_process(delta: float) -> void:
	#var mouse_pos := _get_mouse_pos_in_3d()
	#mouse_pos.y = global_position.y
	#look_at(mouse_pos)
	pass
	

func deal_damage() -> void:
	for enemy in enemies_within_range:
		var health: Health = enemy.get_node("HealthComponent")
		health.damage(attack_damage)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body.has_node("HealthComponent"):
		return
	
	enemies_within_range.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if enemies_within_range.has(body):
		enemies_within_range.erase(body)
