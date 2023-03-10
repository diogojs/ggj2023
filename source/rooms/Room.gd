extends Node2D

signal on_Door_open(new_dir_name)
signal on_Player_enter_File_area(file)
signal on_Player_exit_File_area(file)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name.substr(0, 4) == "Door":
			child.connect("on_Door_open", self, "_on_Door_open")
		if child.name.substr(0, 4) == "File":
			child.connect("on_player_enter", self, "_on_Player_enter_File_area")
			child.connect("on_player_exit", self, "_on_Player_exit_File_area")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#	pass
func _on_Door_open(new_dir_name):
	emit_signal("on_Door_open", new_dir_name)

func get_door(name):
	for child in get_children():
		if child.name.substr(0, 4) == "Door":
			if child.dir_name == name:
				return child

func get_position_at_front(door_name, size):
	var offset = Vector2(0, 25 + (size.y / 2))
	var door = get_door(door_name)
	var door_rect = door.get_rect()
	var center = door_rect.get_center()
	var start = door_rect.position
	var end = door_rect.end
	if door.is_near_top():
		return Vector2(center.x, end.y) + offset
	else:
		return Vector2(center.x, start.y) - offset

func add_file(player_rect: Rect2, file: Node2D):
	var file_rect = file.get_rect()
	var offset = Vector2(0, 10 + (file_rect.size.y / 2))
	var center = player_rect.get_center()
	var end = player_rect.end
	var position = Vector2(center.x, end.y) + offset

	add_child(file)
	file.global_position = position
	file.connect("on_player_enter", self, "_on_Player_enter_File_area")
	file.connect("on_player_exit", self, "_on_Player_exit_File_area")
	
func remove_file(file: Node2D):
	file.disconnect("on_player_enter", self, "_on_Player_enter_File_area")
	file.disconnect("on_player_exit", self, "_on_Player_exit_File_area")
	remove_child(file)

func _on_Player_enter_File_area(file):
	emit_signal("on_Player_enter_File_area", file)
	
func _on_Player_exit_File_area(file):
	emit_signal("on_Player_exit_File_area", file)
