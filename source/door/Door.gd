extends StaticBody2D

signal on_Door_open(dir_name)

# Declare member variables here. Examples:
export var dir_name = ""
export var is_locked = true
var is_open = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	if not is_locked:
		unlock()

func switch_door_status():
	var sprite: Sprite = get_node("Locked" if is_locked else "Unlocked")
	var shape = get_node("CollisionShape2D")
	if is_open:
		sprite.show()
		shape.set_deferred("disabled", false)
	else:
		sprite.hide()
		shape.set_deferred("disabled", true)
	is_open = not is_open

func unlock():
	get_node("Locked").hide()
	get_node("Unlocked").show()
	is_locked = false

func _on_Area2D_body_entered(_body):
	if not is_locked:
		switch_door_status()

func _on_Area2D_body_exited(_body):
	if not is_locked:
		switch_door_status()

func is_near_top():
	return global_position.y < OS.get_window_size().y / 2

func get_rect():
	var coll2D = get_node("Detection/CollisionShape2D")
	var diameter = coll2D.shape.radius * 2
	var size = Vector2(diameter, coll2D.shape.height + diameter)
	return Rect2(coll2D.global_position - (size / 2), size)

func _on_Exit_body_entered(_body):
	emit_signal("on_Door_open", dir_name)
