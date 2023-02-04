extends StaticBody2D

signal on_Door_open(dir_name)

# Declare member variables here. Examples:
export var dir_name = ""
var is_open = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func switch_door_status():
	var sprite = get_node("Sprite")
	if is_open:
		sprite.region_rect.position.x = 0
	else:
		sprite.region_rect.position.x = 6 * 68
	is_open = not is_open

func _on_Area2D_body_entered(body):
	switch_door_status()
	emit_signal("on_Door_open", dir_name)

func _on_Area2D_body_exited(body):
	switch_door_status()