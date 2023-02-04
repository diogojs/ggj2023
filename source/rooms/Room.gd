extends Node2D

var current_dir = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	current_dir = get_tree().current_scene.filename.replace("room.tscn", "")
	
	for child in get_children():
		if child.name.substr(0, 4) == "Door":
			child.connect("on_Door_open", self, "_on_Door_open")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Door_open(new_dir_name):
	var new_scene = current_dir + new_dir_name + "/room.tscn"
	get_tree().change_scene(new_scene)
