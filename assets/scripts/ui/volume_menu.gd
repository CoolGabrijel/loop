extends CanvasLayer

@export var master_audio_bus: String = "Master"
@export var sfx_audio_bus: String = "SFX"
@export var music_audio_bus: String = "Music"
@export var dialogue_audio_bus: String = "Dialogue"

@onready var back_button: Button = $BackButton
@onready var master_volume_slider: HSlider = $MasterVolumeSlider
@onready var sfx_volume_slider: HSlider = $SFXSlider
@onready var music_volume_slider: HSlider = $MusicVolumeSlider
@onready var dialogue_volume_slider: HSlider = $DialogueSlider

var master_bus_index: int
var sfx_bus_index: int
var music_bus_index: int
var dialogue_bus_index: int

signal back_button_was_pressed

const MIN_DB := -30.0
const MAX_DB := 0.0

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	music_bus_index = AudioServer.get_bus_index("Music")
	dialogue_bus_index = AudioServer.get_bus_index("Dialogue")
	
	if master_bus_index != -1:
		master_volume_slider.value = linear_to_db(AudioServer.get_bus_volume_db(master_bus_index))
	# Get bus indices
	master_bus_index = AudioServer.get_bus_index(master_audio_bus)
	sfx_bus_index = AudioServer.get_bus_index(sfx_audio_bus)
	music_bus_index = AudioServer.get_bus_index(music_audio_bus)
	dialogue_bus_index = AudioServer.get_bus_index(dialogue_audio_bus)

	# Configure sliders (percentage UI)
	for slider in [master_volume_slider, sfx_volume_slider, music_volume_slider, dialogue_volume_slider]:
		slider.min_value = 0
		slider.max_value = 100
		slider.step = 1

	# Initialize sliders from bus volumes
	if master_bus_index != -1:
		master_volume_slider.value = _db_to_percentage(AudioServer.get_bus_volume_db(master_bus_index))
	if sfx_bus_index != -1:
		sfx_volume_slider.value = _db_to_percentage(AudioServer.get_bus_volume_db(sfx_bus_index))
	if music_bus_index != -1:
		music_volume_slider.value = _db_to_percentage(AudioServer.get_bus_volume_db(music_bus_index))
	if dialogue_bus_index != -1:
		dialogue_volume_slider.value = _db_to_percentage(AudioServer.get_bus_volume_db(dialogue_bus_index))

	# Clear old connections
	_clear_existing_connections(master_volume_slider, "value_changed")
	_clear_existing_connections(sfx_volume_slider, "value_changed")
	_clear_existing_connections(music_volume_slider, "value_changed")
	_clear_existing_connections(dialogue_volume_slider, "value_changed")
	_clear_existing_connections(back_button, "pressed")

	# Connect sliders
	master_volume_slider.connect("value_changed", Callable(self, "_on_volume_slider_changed").bind(master_bus_index))
	sfx_volume_slider.connect("value_changed", Callable(self, "_on_volume_slider_changed").bind(sfx_bus_index))
	music_volume_slider.connect("value_changed", Callable(self, "_on_volume_slider_changed").bind(music_bus_index))
	dialogue_volume_slider.connect("value_changed", Callable(self, "_on_volume_slider_changed").bind(dialogue_bus_index))
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))

func _on_volume_slider_changed(value: float, bus_index: int) -> void:
	if bus_index != -1:
		if value <= 0.0:
			# Mute the bus at 0%
			AudioServer.set_bus_mute(bus_index, true)
		else:
			# Unmute and set volume
			AudioServer.set_bus_mute(bus_index, false)
			var db_value = _percentage_to_db(value)
			AudioServer.set_bus_volume_db(bus_index, db_value)

func _on_back_button_pressed() -> void:
	emit_signal("back_button_was_pressed")

# Helper: clear any old editor signal connections
func _clear_existing_connections(node: Node, signal_name: String) -> void:
	for connection in node.get_signal_connection_list(signal_name):
		node.disconnect(signal_name, connection.callable)

# Convert dB to percentage
func _db_to_percentage(db: float) -> float:
	if db <= MIN_DB:
		return 0.0
	return clamp(((db - MIN_DB) / (MAX_DB - MIN_DB)) * 100.0, 0.0, 100.0)

# Convert percentage to dB
func _percentage_to_db(percentage: float) -> float:
	return lerp(MIN_DB, MAX_DB, percentage / 100.0)
