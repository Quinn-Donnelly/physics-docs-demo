class_name Grenade 
extends RigidBody2D

var vertical_speed = 200.0
var gravity = 400.0
var has_bounced: bool = false
var explosion_timer: Timer

func start(p: Vector2, r: float):
	global_position = p
	rotation = r

func _ready() -> void:
	gravity_scale = 0
	apply_impulse(Vector2(500,0), global_position)
	linear_damp = 2
	explosion_timer = Timer.new()
	explosion_timer.one_shot = true
	explosion_timer.timeout.connect(self._go_boom)
	explosion_timer.start(1)

func _physics_process(delta):
	vertical_speed -= gravity * delta
	if vertical_speed <= 0 and not has_bounced:
		# Simulate hitting the ground
		apply_central_impulse(Vector2(linear_velocity.x, linear_velocity.y) * 0.2)
		has_bounced = true

