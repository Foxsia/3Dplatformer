extends CharacterBody3D
class_name EnemyBase

@export_group("Movement")
@export var move_speed := 2.5
@export var detection_range := 15.0

@export_group("References")
@export var visual_root: Node3D
@export var animation_tree: AnimationTree
@export var navigation_agent: NavigationAgent3D
@export var health_component: HealthComponent

var target: Node3D = null
var animation_playback: AnimationNodeStateMachinePlayback = null
var is_dead: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	add_to_group("enemy")
	target = get_tree().get_first_node_in_group("player") as Node3D
	
	if animation_tree:
		animation_tree.active = true
		animation_playback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	
	if health_component:
		health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	
	update_enemy_ai(delta)
	move_and_slide()

func update_enemy_ai(_delta: float) -> void:
	pass

func find_player() -> Node3D:
	var player = get_tree().get_first_node_in_group("player") as Node3D
	if not is_instance_valid(player):
		return null
	
	if global_position.distance_to(player.global_position) > detection_range:
		return null
	
	return player

func move_towards_position(destination: Vector3) -> void:
	if not is_instance_valid(navigation_agent):
		stop_movement()
		return
	
	if navigation_agent.target_position.distance_to(destination) > 0.5:
		navigation_agent.target_position = destination
	
	if navigation_agent.is_navigation_finished():
		stop_movement()
		return
	
	var next_position: Vector3 = navigation_agent.get_next_path_position()
	var direction: Vector3 = next_position - global_position
	direction.y = 0.0
	
	if direction.length_squared() < 0.04:
		stop_movement()
		return
	
	direction = direction.normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	
	play_animation("walk")

func stop_movement() -> void:
	velocity.x = 0.0
	velocity.z = 0.0
	play_animation("idle")

func play_animation(animation_name: String) -> void:
	if animation_playback:
		animation_playback.travel(animation_name)

func take_damage(amount: float) -> void:
	if not health_component or is_dead:
		return
	
	health_component.take_damage(amount)

func face_target(node: Node3D):
	if not is_instance_valid(node):
		return
	
	var direction: Vector3 = node.global_position - self.global_position
	direction.y = 0.0
	
	if is_instance_valid(visual_root):
		visual_root.look_at(
			visual_root.global_position + direction,
			Vector3.UP
		)
		visual_root.rotate_y(PI)

func _on_died() -> void:
	if is_dead:
		return
	
	is_dead = true
	queue_free()
