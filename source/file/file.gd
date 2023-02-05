extends StaticBody2D

signal on_player_enter(file)
signal on_player_exit(file)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_rect() -> Rect2:
	var size = $CollisionShape2D.shape.extents
	return Rect2($CollisionShape2D.global_position - size / 2, size)


func _on_Area2D_body_entered(body):
	emit_signal("on_player_enter", self)


func _on_Area2D_body_exited(body):
	emit_signal("on_player_exit", self)
