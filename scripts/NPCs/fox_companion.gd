extends CharacterBody3D
class_name FoxCompanion

@export_group("Follow")
@export var move_speed: float = 4.0
@export var acceleration: float = 10.0
@export var follow_distance: float = 2.0

@export_group("Movement")
@export var gravity: float = 9.8

@export_group("References")
@export var navigation_agent: NavigationAgent3D
@export var visual_root: Node3D

var target: CharacterBody3D

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player") as CharacterBody3D
	
	if navigation_agent:
		navigation_agent.path_desired_distance = 0.5
		navigation_agent.target_desired_distance = follow_distance

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	 
	var offset := target.global_position - global_position
	offset.y = 0.0
	var distance := offset.length()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	
	if not navigation_agent:
		move_and_slide()
		return
	
	if distance > follow_distance:
		navigation_agent.target_position = target.global_position
		
		if not navigation_agent.is_navigation_finished():
			move_to_next_position(delta)
		else:
			stop_movement(delta)
	else:
		stop_movement(delta)
	move_and_slide()

func move_to_next_position(delta: float) -> void:
	var next_position := navigation_agent.get_next_path_position()
	
	var direction := next_position - global_position
	direction.y = 0.0
	
	if direction.length_squared() < 0.01:
		stop_movement(delta)
		return
	
	direction = direction.normalized()
	
	velocity.x = move_toward(
		velocity.x,
		direction.x * move_speed,
		acceleration * delta
	)
	
	velocity.z = move_toward(
		velocity.z,
		direction.z * move_speed,
		acceleration * delta
	)
	
	if visual_root:
		visual_root.rotation.y = lerp_angle(
			visual_root.rotation.y,
			atan2(-direction.x, -direction.z) + PI,
			minf(8.0 * delta, 1.0)
		)
	else:
		rotation.y = lerp_angle(
			rotation.y,
			atan2(-direction.x, -direction.z) + PI,
			minf(8.0 * delta, 1.0)
		)

func stop_movement(delta: float) -> void:
	velocity.x = move_toward(
		velocity.x, 0.0, acceleration * delta
	)
	
	velocity.z = move_toward(
		velocity.z, 0.0, acceleration * delta
	)
