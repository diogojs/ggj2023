extends KinematicBody2D


# Declare member variables here. Examples:
var _velocity: Vector2
var speed := 250.0
var speed_damping := 0.6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	
	input = input.normalized()
	
	_velocity = _velocity.linear_interpolate(input * speed, speed_damping)
	_velocity = move_and_slide(_velocity, Vector2.UP)
