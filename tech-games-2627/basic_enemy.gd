extends CharacterBody2D

@export var speed: float = 150.0
@onready var timer: Timer = $Timer
var screen_size

var movement_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size
	randomize()
	timer.start()
	choose_new_direction()

func _physics_process(delta: float) -> void:
	velocity = movement_direction * speed
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)
	

func choose_new_direction() -> void:
	var random_x = randf_range(-1.0, 1.0)
	var random_y = randf_range(-1.0, 1.0)
	movement_direction = Vector2(random_x, random_y).normalized()

func _on_timer_timeout() -> void:
	choose_new_direction()
	timer.wait_time = randf_range(1.5, 4.0)
