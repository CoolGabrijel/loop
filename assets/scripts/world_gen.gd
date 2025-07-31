extends Node

@export var room_components: Array[PackedScene]
@export var max_depth: int = 4

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var starter_room: Room = room_components[0].instantiate()
	add_child(starter_room)
	for connection in starter_room.connection_points:
		generate_room(0, connection)

func generate_room(depth: int, parent_connection: RoomConnection) -> void:
	var possible_rooms := room_components.duplicate()
	while possible_rooms.size() > 0:
		
		var rand_index: int = rng.randi_range(0, possible_rooms.size()-1)
		var room: Room = room_components[rand_index].instantiate()
		
		var room_pos := Vector3.ZERO
		for connection in room.connection_points:
			if connection.occupied:
				continue
			if parent_connection.get_opposite_direction() == connection.direction:
				print(parent_connection.get_opposite_direction(), " ", connection.direction)
				if parent_connection.occupied:
					continue
				var parent_global_pos = parent_connection.global_position
				var local_pos = connection.position
				room_pos = parent_global_pos - local_pos
				connection.occupied = true
				parent_connection.occupied = true
				break
		
		if room_pos == Vector3.ZERO:
			room.queue_free()
			return
		
		add_child(room)
		room.global_position = room_pos
		
		if depth >= max_depth:
			return
		
		for connection in room.connection_points:
			var chance_to_spawn_room = rng.randf()
			if chance_to_spawn_room > 0.25:
				await get_tree().process_frame
				generate_room(depth + 1, connection)
				possible_rooms.clear()
