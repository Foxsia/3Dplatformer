extends CharacterBody3D

@export var speed := 2.0
@export var patrol_point_1: Node3D
@export var patrol_point_2: Node3D
@onready var mesh = $"animal-bee2"

@onready var patrol_component: PatrolComponent = $PatrolComponent

@onready var damage_area: Area3D = $DamageArea

@onready var animation_tree: AnimationTree = $"animal-bee2/AnimationTree"

var animation_playback

var current_target: Node3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	current_target = patrol_point_1
	
	animation_tree.active = true
	animation_playback = animation_tree.get("parameters/playback")
	damage_area.body_entered.connect(_on_damage_area_body_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if current_target == null:
		return
	
	var  direction = patrol_component.get_direction_to_target(
		global_position,
		current_target.global_position
	)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if direction != Vector3.ZERO:
		mesh.look_at(mesh.global_position + direction, Vector3.UP)
		mesh.rotate_y(PI)
		animation_playback.travel("walk")
	else:
		animation_playback.travel("idle")
	
	if patrol_component.has_reached_target(global_position, current_target.global_position):
		if current_target == patrol_point_1:
			current_target = patrol_point_2
		else:
			current_target = patrol_point_1
	
	move_and_slide()

func _on_damage_area_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	
	if body.velocity.y < 0 and body.global_position.y > global_position.y + 0.3:
		queue_free()
		body.velocity.y = 7.0
	else:
		body.die()
