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


func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	music_bus_index = AudioServer.get_bus_index("Music")
	dialogue_bus_index = AudioServer.get_bus_index("Dialogue")
	
	if master_bus_index != -1:
		master_volume_slider.value = linear_to_db(AudioServer.get_bus_volume_db(master_bus_index))

	if sfx_bus_index != -1:
		sfx_volume_slider.value = linear_to_db(AudioServer.get_bus_volume_db(sfx_bus_index))	
		
	if music_bus_index != -1:
		music_volume_slider.value = linear_to_db(AudioServer.get_bus_volume_db(music_bus_index))	
		
	if dialogue_bus_index != -1:
		dialogue_volume_slider.value = linear_to_db(AudioServer.get_bus_volume_db(dialogue_bus_index))
		

func _on_back_button_pressed() -> void:
	emit_signal("back_button_was_pressed")


func _on_master_volume_slider_value_changed(value: float) -> void:
	if master_bus_index != -1:
		AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	if sfx_bus_index != -1:
		AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))


func _on_music_volume_slider_value_changed(value: float) -> void:
	if music_bus_index != -1:
		AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))


func _on_dialogue_slider_value_changed(value: float) -> void:
	if dialogue_bus_index != -1:
		AudioServer.set_bus_volume_db(dialogue_bus_index, linear_to_db(value))
