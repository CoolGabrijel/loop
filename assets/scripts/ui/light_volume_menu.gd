extends CanvasLayer

const BUS_NAMES := {
	"Master": "Master",
	"Music":  "Music",
	"SFX":    "SFX",
	"Voice":  "Voice"
}

func _ready():
	for bus_name in BUS_NAMES.keys():
		var slider = get_node(NodePath(BUS_NAMES[bus_name]))  
		var bus_index = AudioServer.get_bus_index(bus_name)
		
		if bus_index == -1:
			push_error("Audio bus not found: %s" % bus_name)
			continue
		
		slider.min_value = -72
		slider.max_value = -0.5
		slider.step = 0.1
		slider.value = AudioServer.get_bus_volume_db(bus_index)
		slider.connect("value_changed", Callable(self, "_on_volume_slider_value_changed").bind(bus_name))

func _on_volume_slider_value_changed(value: float, bus_name: String) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, value)
