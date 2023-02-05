extends StaticBody2D

# Declare member variables here. Examples:
var turn_on = false

func _on_Area2D_body_entered(body):
	turn_on = true

func _on_Area2D_body_exited(body):
	turn_on = false
