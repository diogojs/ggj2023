extends Node2D

export var current_dir = "/"
var scene_changing = false
var selected_file = null
var scenes_dict = {}

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
		current_dir += "/" + new_dir_name
		return ".."
	else:
		var idx = current_dir.rfind("/")
		var old_name = current_dir.substr(idx + 1)
		current_dir = current_dir.substr(0, idx)
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
	scenes_dict[current_dir] = old_room
	
	var old_dir = change_directory(new_dir_name)
	
	if not scenes_dict.has(current_dir):
		var scene_filename = "res://rooms" + current_dir + "/room.tscn" 
		var new_room_scene = load(scene_filename)
		scenes_dict[current_dir] = new_room_scene.instance()
	
	var new_room = scenes_dict[current_dir]
	new_room.name = "CurrentRoom"
	add_child(new_room, true)
	new_room.connect("on_Door_open", self, "_on_Door_open")
	new_room.connect("on_Player_enter_File_area", self, "_on_Player_enter_File_area")
	new_room.connect("on_Player_exit_File_area", self, "_on_Player_exit_File_area")
	
	change_player_position(new_room, old_dir)
	$Timer.start()


func _on_Timer_timeout():
	scene_changing = false # Replace with function body.

func _on_Player_enter_File_area(file: Node2D):
	print("Player entered")
	selected_file = file
	
func _on_Player_exit_File_area(file: Node2D):
	print("Player exit")
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
