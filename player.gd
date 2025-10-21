extends CharacterBody2D

var Bullet = preload("res://bullet.tscn")
var grenadeScene: PackedScene = preload("res://quinn-things/grenade.tscn")
var speed = 200

func get_input():
	# Add these actions in Project Settings -> Input Map.
	var input_dir = Input.get_vector("left", "right", "forward", "backward",)
	velocity = input_dir * speed
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("grenade"):
		throwGrenade()

func shoot():
	# "Muzzle" is a Marker2D placed at the barrel of the gun.
	var b = Bullet.instantiate()
	b.start($Muzzle.global_position, rotation)
	get_tree().root.add_child(b)

func throwGrenade():
	var g: Grenade = grenadeScene.instantiate()
	g.start($Muzzle.global_position, rotation)
	get_tree().root.add_child(g)

func _physics_process(_delta):
	get_input()
	var dir = get_global_mouse_position() - global_position
	# Don't move if too close to the mouse pointer.
	if dir.length() > 5:
		#rotation = dir.angle()
		move_and_slide()
