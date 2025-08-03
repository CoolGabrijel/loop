extends Node2D

@onready var label = $Label

var intro = ["Omega Corp. They make everything and anything there, including miserable people like Jeremy.", #1
"He used to be optimistic. Bright. Vibrant, even.", # 2
"But the corporate machine grinds everyone to dust eventually.", # 3
"A bogus report and a vengeful CEO later, Jeremy found himself on the street, once again looking for a new job.", #4
"But every morning, he'd look out his apartment window,", #5
"and see the Omega Corp. building looming in the distance, towering over the rest of the city.",
"Reminding him. Taunting him. Challenging him.",
"No more. Today was the day.",
"He jumped in his car and sped towards the office.", 
"When Jeremy arrived, he tightened his tie and rolled up his sleeves.", #6
"He's only met Mr. Omega once, on his first day, and his whole life has gone downhill ever since.",
"But they'd meet again. And again. And again.",
"As many times as it took,  ", 
"until Jeremy delivered his message to the ruler of the most powerful organisation in the world."]

@onready var texture: TextureRect = $TextureRect

# FRAMES
const _2 = preload("res://assets/sprites/intro/2.png")
const _3 = preload("res://assets/sprites/intro/3.png")
const _4 = preload("res://assets/sprites/intro/4.png")
const _5 = preload("res://assets/sprites/intro/5.png")
const _6 = preload("res://assets/sprites/intro/6.png")

var current_line = 0

signal intro_has_ended


func _ready(): 
	update_intro()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		advance_intro()


func update_intro():
	label.text = intro[current_line]
	if current_line == 2:
		texture.texture = _2
	if current_line == 3:
		texture.texture = _3
	if current_line == 4:
		texture.texture = _4
	if current_line == 5:
		texture.texture = _5
	if current_line == 10:
		texture.texture = _6


func advance_intro():
	current_line += 1
	if current_line < intro.size():
		update_intro()
	else: 
		print("Intro ended")
		emit_signal("intro_has_ended")
		queue_free()
