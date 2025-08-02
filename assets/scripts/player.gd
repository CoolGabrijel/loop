extends CharacterBody3D
class_name Player

static var player: Player

@onready var health_node: Health = $Health
@onready var controller: Node = $PlayerController

func _ready() -> void:
	player = self
	
	
