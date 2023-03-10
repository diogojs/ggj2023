extends Node2D

export var current_dir = "/"
var scene_changing = false
var selected_file = null
var rooms_dict = {}
onready var terminal := $Terminal

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_room = get_node("CurrentRoom")
	current_room.connect("on_Door_open", self, "_on_Door_open")
	current_room.connect("on_Player_enter_File_area", self, "_on_Player_enter_File_area")
	current_room.connect("on_Player_exit_File_area", self, "_on_Player_exit_File_area")
	
	var terminal = get_node("Terminal")
	terminal.connect("on_copy_File", self, "_on_copy_File")
	terminal.connect("on_paste_File", self, "_on_paste_File")
	
func change_directory(new_dir_name):	
	if new_dir_name != "..":
		if current_dir != "/":
			current_dir += "/"
		current_dir += new_dir_name
		return ".."
	else:
		var idx = current_dir.rfind("/")
		var old_name = current_dir.substr(idx + 1)
		current_dir = current_dir.substr(0, idx)
		if current_dir == "":
			current_dir = "/"
		return old_name
		
		
func change_player_position(room, door_name):
	var player = get_node("Player/KinematicBody2D")
	var shape = player.get_node("CollisionShape2D").shape
	var new_position = room.get_position_at_front(door_name, shape.extents)
	player.global_position = new_position

func _on_Door_open(new_dir_name):
	if scene_changing:
		return
	scene_changing = true
	
	var old_room = get_node("CurrentRoom")
	old_room.disconnect("on_Door_open", self, "_on_Door_open")
	old_room.disconnect("on_Player_enter_File_area", self, "_on_Player_enter_File_area")
	old_room.disconnect("on_Player_exit_File_area", self, "_on_Player_exit_File_area")
	remove_child(old_room)
	rooms_dict[current_dir] = old_room
	
	var old_dir = change_directory(new_dir_name)
	
	if not rooms_dict.has(current_dir):
		var scene_filename = "res://rooms" + current_dir + "/room.tscn" 
		var new_room_scene = load(scene_filename)
		rooms_dict[current_dir] = new_room_scene.instance()
	
	var new_room = rooms_dict[current_dir]
	new_room.name = "CurrentRoom"
	add_child(new_room, true)
	new_room.connect("on_Door_open", self, "_on_Door_open")
	new_room.connect("on_Player_enter_File_area", self, "_on_Player_enter_File_area")
	new_room.connect("on_Player_exit_File_area", self, "_on_Player_exit_File_area")
	
	connect_interactives_to_terminal(new_room)
	
	change_player_position(new_room, old_dir)
	$Timer.start()

func connect_interactives_to_terminal(room_scene: Node2D):
	var interactives = Array()
	find_child_by_name(self, "Readable", interactives)

	for interactive in interactives:
		interactive.connect("access_denied", terminal, "_on_access_denied")

func find_child_by_name(from, name: String, array_of_children):
	for child in from.get_children():
		if child.name == "Readable":
			array_of_children.append(child)
		else:
			find_child_by_name(child, name, array_of_children)

func _on_Timer_timeout():
	scene_changing = false # Replace with function body.

func _on_Player_enter_File_area(file: Node2D):
	selected_file = file
	
func _on_Player_exit_File_area(_file: Node2D):
	selected_file = null
	
func _on_copy_File():
	if selected_file == null:
		return
	
	var room = get_node("CurrentRoom")
	var transfer_area = get_node("TransferArea")
	room.remove_file(selected_file)
	transfer_area.push_item(selected_file)
	selected_file = null

func _on_paste_File():
	var transfer_area = get_node("TransferArea")
	var file = transfer_area.pop_item()
	if file == null:
		return
	
	var player = get_node("Player/KinematicBody2D")
	var room = get_node("CurrentRoom")
	room.add_file(player.get_rect(), file)
	
	# workaround
	if current_dir == "/sys/firmware":
		var door = rooms_dict["/"].get_door("root")
		door.unlock()
		terminal.add_text("\n[color=green]Unlocked /root[/color]")

func unlock_sys_dir() -> bool:
	if current_dir == "/home/stallman":
		var room = get_node("CurrentRoom")
		if room.get_node("Write").turn_on:
			var door = rooms_dict["/"].get_door("sys")
			door.unlock()
			terminal.add_text("[color=green]\nUnlocked /sys[/color]")
			return true
	return false
