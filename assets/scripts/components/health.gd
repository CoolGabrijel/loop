@icon("res://assets/sprites/ui/hud_heart_half.png")
extends Node
class_name Health

signal on_death
signal on_damage
signal on_heal

@export var base_max_hp := 10

var current_hp: int

func _ready() -> void:
	current_hp = base_max_hp

func heal(amount: int) -> void:
	current_hp += amount
	if current_hp >= base_max_hp:
		current_hp = base_max_hp
	
	on_heal.emit()

func damage(amount: int) -> void:
	current_hp -= amount
	
	if current_hp <= 0:
		current_hp = 0
		on_death.emit()
	else:
		on_damage.emit()
