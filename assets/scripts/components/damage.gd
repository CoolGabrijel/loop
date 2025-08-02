extends Node3D
class_name Damage

@export_flags_3d_physics var mouse_pos_mask
@export var attack_damage: int
@export var attack_speed: float
@export var dot_damage: float
@export var vulnerability: int
@export var shield: int

@export var detection_range: float
@export var attack_range: float

@export var is_range_attack: bool
@export var bullet_speed: float

@onready var camera: Camera3D = $"../Camera3D"

var enemies_within_range: Array[Node3D]

func _physics_process(delta: float) -> void:
	var mouse_pos := _get_mouse_pos_in_3d()
	mouse_pos.y = global_position.y
	look_at(mouse_pos)

func _unhandled_input(event: InputEvent) -> void:
	if !event.is_action_pressed("Attack"):
		return
	
	deal_damage()

func deal_damage() -> void:
	for enemy in enemies_within_range:
		var health: Health = enemy.get_node("Health")
		health.damage(attack_damage)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body.has_node("Health"):
		return
	
	enemies_within_range.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if enemies_within_range.has(body):
		enemies_within_range.erase(body)

func _get_mouse_pos_in_3d() -> Vector3:
	var space_state := get_world_3d().direct_space_state
	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := camera.project_ray_normal(mouse_pos) * 1000
	var query := PhysicsRayQueryParameters3D.create(from, to, mouse_pos_mask)
	var result := space_state.intersect_ray(query)
	
	if result["collider"] != null:
		return result["position"]
	return Vector3.ZERO

