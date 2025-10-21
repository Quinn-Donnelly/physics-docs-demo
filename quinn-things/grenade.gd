class_name Grenade 
extends RigidBody2D

var vertical_speed = 200.0
var gravity = 400.0
var has_bounced: bool = false
var explosion_timer: Timer
var explode: bool = false
@export var explosion_radius: float = 1000

func start(p: Vector2, r: float):
	global_position = p
	rotation = r

func _ready() -> void:
	gravity_scale = 0
	apply_impulse(Vector2(500,0), global_position)
	linear_damp = 2
	explosion_timer = Timer.new()
	explosion_timer.one_shot = true
	get_tree().root.add_child(explosion_timer)
	explosion_timer.timeout.connect(self._set_explode)
	explosion_timer.start(1)

func _physics_process(_delta):
	if explode:
		_go_boom()

func _go_boom() -> void:
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	var shape: Shape2D = CircleShape2D.new()
	shape.radius = explosion_radius
	query.shape = shape
	query.exclude = [self]
	
	var results: Array[Dictionary] = get_world_2d().direct_space_state.intersect_shape(query)
	for result in results:
		var obj: Object = result.collider
		if obj.has_method("apply_impulse"):
			obj.apply_impulse((obj.global_position - global_position) * 3)
	queue_free()

func _set_explode() -> void:
	explode = true
