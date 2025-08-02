extends Node

class_name Speed

@export var base_speed: float

var speed_modifier: float = 0

var total_speed: float:
	get:
		return base_speed+speed_modifier
