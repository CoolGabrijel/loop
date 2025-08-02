extends Area3D

var has_been_picked_up := false

func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	if has_been_picked_up:
		return
	
	Player.player.health_node.heal(5)
	has_been_picked_up = true
	print("Health Pickup :: pickup was picked, health regained!")
	queue_free()
