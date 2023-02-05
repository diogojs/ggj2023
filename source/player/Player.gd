extends KinematicBody2D


# Declare member variables here. Examples:
var _velocity: Vector2
export var speed := 250.0
var speed_damping := 0.6

export var permissions = {
	"read": 0,
	"write": 0,
	"execute": 0
}

var _directions := {Vector2.LEFT: "RIGHT", Vector2.RIGHT: "RIGHT", Vector2.DOWN: "DOWN", Vector2.UP: "UP"}

onready var animated_sprite: AnimatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")
	animated_sprite.stop()
	animated_sprite.frame = 0

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
	_update_animation(input)
	
	_velocity = _velocity.linear_interpolate(input * speed, speed_damping)
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _update_animation(direction: Vector2) -> void:
	var walking = (direction != Vector2.ZERO)
	
	if direction.x != 0 and direction.y != 0:
		direction.x = 0
		direction.y = -1 if direction.y < 0 else 1
	
	if walking:
		var _animation: String = _directions[direction]
		animated_sprite.flip_h = false
		if direction == Vector2.LEFT:
			animated_sprite.flip_h = true

		_animation = "walk_" + _animation
		animated_sprite.play(_animation.to_lower())
	else:
		animated_sprite.play("idle")
		animated_sprite.stop()

func get_level(permission_flag: String):
	return permissions[permission_flag]
	
func get_rect() -> Rect2:
	var coll2D = get_node("CollisionShape2D")
	var size = coll2D.shape.extents
	return Rect2(coll2D.global_position - size / 2, size)
