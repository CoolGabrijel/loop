extends Node2D

var intro = ["Omega Corp. They make everything and anything there, including miserable people like Jeremy.",
"He used to be optimistic. Bright. Vibrant, even.",
"But the corporate machine grinds everyone to dust eventually.",
"A bogus report and a vengeful CEO later, Jeremy found himself on the street, once again looking for a new job.",
"But every morning, he'd look out his apartment window,",
"and see the Omega Corp. building looming in the distance, towering over the rest of the city.",
"Reminding him. Taunting him. Challenging him.",
"No more. Today was the day.",
"He jumped in his car and sped towards the office.",
"When Jeremy arrived, he tightened his tie and rolled up his sleeves.",
"He's only met Mr. Omega once, on his first day, and his whole life has gone downhill ever since.",
"But they'd meet again. And again. And again.",
"As many times as it took,  ", 
"until Jeremy delivered his message to the ruler of the most powerful organisation in the world."]

@onready var label = $Label

var current_line = 0

signal intro_has_ended


func _ready(): 
	update_intro()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		advance_intro()


func update_intro():
	label.text = intro[current_line]


func advance_intro():
	current_line += 1
	if current_line < intro.size():
		update_intro()
	else: 
		print("Intro ended")
		emit_signal("intro_has_ended")
		queue_free()
