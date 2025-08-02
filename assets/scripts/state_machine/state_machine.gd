extends Node

@onready var attack_timer: Timer = $AttackTimer

@export var starting_state: State
@export var enable_combination_shoot_stun: bool = false

var current_state: State
var can_attack: bool = false

# For checking if character
var is_combination_enabled = false

# For making sure that after shoot there will be stun
var has_stun_combination_finished = true

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent: CharacterBody3D) -> void:
	for child in get_children():
		if child is State:
			child.parent = parent

	# Initialize to the default state
	change_state(starting_state)
	
	reset_attack_timer()
	attack_timer.wait_time = parent.attack_speed
	
	is_combination_enabled = enable_combination_shoot_stun
	
# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	#print(current_state)
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
		
		
func reset_attack_timer() -> void:
	can_attack = false
	attack_timer.start()
	
func _on_attack_timer_timeout() -> void:
	can_attack = true
