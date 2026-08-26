extends CharacterBody3D

signal lives_changed(new_lives)

const SPEED := 5.0
const JUMP_VELOCITY := 6
const  MAX_JUMPS := 2

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed_multiplier := 1.0
var is_running := false
var jumps_left := MAX_JUMPS

@export var sens := 0.5
@export var max_lives := 3

var lives := max_lives
var checkpoint_position : Vector3
var is_dead := false

@onready var pivot = $CameraOrigin
@onready var pitch = $CameraOrigin/CameraPitch
@onready var mesh = get_node("animal-fox2/animal-fox")
@onready var animation_tree = get_node("animal-fox2/AnimationTree")

@onready var raycast: RayCast3D = $RayCast3D

@onready var spring_arm: SpringArm3D = $CameraOrigin/CameraPitch/SpringArm3D

var animation_playback

var state_machine: PlayerStateMachine

var idle_state: PlayerIdleState
var walk_state: PlayerWalkState
var run_state: PlayerRunState
var jump_state: PlayerJumpState
var fall_state: PlayerFallState

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	checkpoint_position = global_position
	add_to_group("player")
	
	animation_tree.active = true
	animation_playback = animation_tree.get("parameters/playback")
	
	mesh.rotation.y += PI
	
	idle_state = PlayerIdleState.new(self)
	walk_state = PlayerWalkState.new(self)
	run_state = PlayerRunState.new(self)
	jump_state = PlayerJumpState.new(self)
	fall_state = PlayerFallState.new(self)
	
	state_machine = PlayerStateMachine.new()
	state_machine.initialize(idle_state)

func _input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * sens))
		pitch.rotate_x(deg_to_rad(-event.relative.y * sens))
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-60), deg_to_rad(45))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
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
		raycast.look_at(raycast.global_position + direction, Vector3.UP)

		mesh.rotation.y = lerp_angle(
			mesh.rotation.y,
			atan2(-direction.x, -direction.z) + PI,
			delta * 10
		)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	state_machine.physics_update(delta)
	
	move_and_slide()
	
	if global_position.y < -10:
		die()
	
	if raycast.is_colliding():
		print("HIT: ", raycast.get_collider().name)


func die():
	if is_dead:
		return
	
	is_dead = true
	lives -= 1
	
	lives_changed.emit(lives)
	
	if lives <= 0:
		game_over()
	else:
		respawn()

func respawn():
	global_position = checkpoint_position
	velocity = Vector3.ZERO
	jumps_left = MAX_JUMPS
	is_dead = false

func game_over():
	get_tree().reload_current_scene.call_deferred()

func set_checkpoint(new_position: Vector3):
	checkpoint_position = new_position

func  play_animation(animation_name: String) -> void:
	animation_playback.travel(animation_name)

func is_moving() -> bool:
	var input_dir = Input.get_vector("left", "right", "down", "up")
	return input_dir.length() > 0.0
