extends CharacterBody3D
class_name FoxCompanion

@export_group("Follow")
@export var move_speed: float = 4.0
@export var acceleration: float = 10.0
@export var follow_distance: float = 2.2
@export var teleport_distance: float = 15.0

@export_group("Movement")
@export var gravity: float = 9.8

var target: CharacterBody3D

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	var offset := target.global_position - global_position
	offset.y = 0.0
	var distance := offset.length()
	
	if distance > teleport_distance:
		global_position = target.global_position + Vector3(5.0, 0.0, 5.0)
		velocity = Vector3.ZERO
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	
	if distance > follow_distance:
		var direction := offset.normalized()
		
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
		
		rotation.y = lerp_angle(
			rotation.y,
			atan2(-direction.x, -direction.z) + PI,
			minf(8.0 * delta, 1.0)
		)
	else:
		velocity.x = move_toward(
			velocity.x, 0.0, acceleration * delta
		)
		velocity.z = move_toward(
			velocity.z, 0.0, acceleration * delta
		)
	move_and_slide()
