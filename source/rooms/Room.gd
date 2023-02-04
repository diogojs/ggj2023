extends Node2D

signal on_Door_open(new_dir_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name.substr(0, 4) == "Door":
			child.connect("on_Door_open", self, "_on_Door_open")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#	pass
func _on_Door_open(new_dir_name):
	emit_signal("on_Door_open", new_dir_name)


func get_position_at_front(door_name, size):
	for child in get_children():
		if child.name.substr(0, 4) == "Door":
			if child.dir_name == door_name:
				var rect = child.get_rect()
				if child.rotation == 0:
					return rect.position \
						+ Vector2(rect.size.x / 2, rect.size.y + 10) \
						+ Vector2(0, size.y / 2)
				else:
					return rect.position \
						+ Vector2(rect.size.x / 2, -10) \
						- Vector2(0, size.y / 2)
