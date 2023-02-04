extends Node2D

export var current_dir = "/root"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var current_room = get_node("CurrentRoom")
	current_room.connect("on_Door_open", self, "_on_Door_open")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	var player = $Player
	var shape = player.get_node("KinematicBody2D/CollisionShape2D").shape
	var new_position = room.get_position_at_front(door_name, shape.extents)
	player.position = new_position

func _on_Door_open(new_dir_name):
	var old_room = $CurrentRoom
	old_room.disconnect("on_Door_open", self, "_on_Door_open")
	remove_child(old_room)
	old_room.queue_free()
	
	var old_dir = change_directory(new_dir_name)
	
	var scene_filename = "res://rooms" + current_dir + "/room.tscn" 
	var new_room_scene = load(scene_filename)
	var new_room = new_room_scene.instance()
	new_room.name = "CurrentRoom"
	add_child(new_room, true)
	new_room.connect("on_Door_open", self, "_on_Door_open")
	
	change_player_position(new_room, old_dir)
