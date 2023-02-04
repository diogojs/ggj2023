extends StaticBody2D


# Declare member variables here. Examples:
var dir_name = ""
var is_open = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func open_or_close():
	var sprite = get_node("Sprite")
	if is_open:
		sprite.region_rect.position.x = 0
	else:
		sprite.region_rect.position.x = 6 * 68
	is_open = not is_open


func _on_Area2D_body_entered(body):
	open_or_close()
