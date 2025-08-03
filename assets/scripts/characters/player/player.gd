extends CharacterBody3D
class_name Player

static var player: Player

@onready var health_node: Health = $HealthComponent
@onready var controller: Node = $PlayerController
@onready var damage_node: Damage = $Damage
@onready var speed_component: Speed = $SpeedComponent

var is_dead = false

func _ready() -> void:
	player = self

func _on_death() -> void:
	is_dead = true
	UIManager.instance._on_death()
