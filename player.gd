extends CharacterBody3D


const SPEED := 5.0
const JUMP_VELOCITY := 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed_multiplier := 1.0
var is_running := false

@export var sens := 0.5
@export var max_lives := 3
var lives := max_lives

var checkpoint_position : Vector3
var is_dead := false

@onready var pivot = $CameraOrigin
@onready var pitch = $CameraOrigin/CameraPitch
@onready var mesh = $BodyMesh

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	checkpoint_position = global_position
	add_to_group("player")

func _input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * sens))
		pitch.rotate_x(deg_to_rad(-event.relative.y * sens))
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-60), deg_to_rad(45))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_pressed("sprint"):
		speed_multiplier = 2.0
		is_running = true
	else:
		speed_multiplier = 1.0
		is_running = false

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var forward = -pivot.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()

	var right = pivot.global_transform.basis.x
	right.y = 0
	right = right.normalized()

	var direction = (right * input_dir.x - forward * input_dir.y).normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED * speed_multiplier
		velocity.z = direction.z * SPEED * speed_multiplier

		mesh.rotation.y = lerp_angle(
			mesh.rotation.y,
			atan2(-direction.x, -direction.z),
			delta * 10
		)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if global_position.y < -10:
		die()

func die():
	if is_dead:
		return
	
	is_dead = true
	lives -= 1
	
	print(lives)
	
	if lives <= 0:
		game_over()
	else:
		respawn()

func respawn():
	global_position = checkpoint_position
	velocity = Vector3.ZERO
	is_dead = false

func game_over():
	print("GameOVER")
	get_tree().reload_current_scene()

func set_checkpoint(new_position: Vector3):
	checkpoint_position = new_position
