extends Node

@export var room_components: Array[PackedScene]
@export var boss_room_component: PackedScene
@export var max_depth: int = 4

var rng = RandomNumberGenerator.new()
var final_room: Room

func _ready() -> void:
	var starter_room: Room = room_components[0].instantiate()
	add_child(starter_room)
	for connection in starter_room.connection_points:
		await generate_room(0, connection)
	
	spawn_boss_room()

func spawn_boss_room() -> void:
	var boss_room: Room = boss_room_component.instantiate()
	add_child(boss_room)
	
	var room_pos := Vector3.ZERO
	var found_room := false
	for connection in final_room.connection_points:
		if found_room:
			break
		if connection.occupied:
			continue
		for boss_connection in boss_room.connection_points:
			if boss_connection.get_opposite_direction() == connection.direction:
				var parent_global_pos = connection.global_position
				var local_pos = boss_connection.position
				room_pos = parent_global_pos - local_pos
				boss_connection.occupied = true
				found_room = true
				break
	
	boss_room.global_position = room_pos
	print(final_room.global_position)

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
		
		final_room = room
		add_child(room)
		room.global_position = room_pos
		room.spawn_enemies()
		
		if depth >= max_depth:
			return
		
		for connection in room.connection_points:
			var chance_to_spawn_room = rng.randf()
			if chance_to_spawn_room > 0.25:
				await get_tree().process_frame
				await generate_room(depth + 1, connection)
				possible_rooms.clear()

## Trust me. It is necessary. The rooms take a process_frame to generate each, and the boss room needs to spawn last
func _wait_a_bunch() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
