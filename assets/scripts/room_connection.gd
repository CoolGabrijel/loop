extends Node3D
class_name RoomConnection

enum Direction {North, East, South, West}

@export var direction: Direction

var occupied: bool = false

func get_opposite_direction() -> Direction:
	if direction == Direction.North:
		return Direction.South
	elif direction == Direction.East:
		return Direction.West
	elif direction == Direction.South:
		return Direction.North
	elif direction == Direction.West:
		return Direction.East
	return Direction.North
