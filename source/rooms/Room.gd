extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name.substr(0, 4) == "Door":
			child.connect("on_Door_open", self, "_on_Door_open")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Door_open(dir_name):
	print(dir_name)
