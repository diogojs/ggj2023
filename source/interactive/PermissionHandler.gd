extends Area2D

export var permissions = {
	"read": 9,
	"write": 9,
	"execute": 9
}

var interactive

func _ready():
	interactive = get_parent().get_node("Interactive")

func _on_body_entered(body):
	if body.get_parent().name != "Player":
		return
	
	for perm in permissions:
		if body.get_level(perm) > permissions[perm]:
			interactive.get_child(0).interage()
			return
	
	interactive.get_child(0).on_access_denied()
