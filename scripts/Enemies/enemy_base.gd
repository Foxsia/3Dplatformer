extends CharacterBody3D
class_name EnemyBase

@export_group("Movement")
@export var detection_range := 10.0

@export_group("References")
@export var visual_root: Node3D
@export var animation_tree: AnimationTree
@export var navigation_agent: NavigationAgent3D
@export var health_component: HealthComponent
@export var ability: Ability
@export var movement_component: EnemyMovementComponent


var target: Node3D = null
var animation_playback: AnimationNodeStateMachinePlayback = null
var is_dead: bool = false
var is_attacking: bool = false
var is_hit: bool = false
var wants_to_move: bool = false


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var state_machine: EnemyStateMachine

var idle_state: EnemyIdleState
var chase_state: EnemyChaseState
var attack_state: EnemyAttackState
var hit_state: EnemyHitState
var death_state: EnemyDeathState

func _ready() -> void:
	add_to_group("enemy")
	target = get_tree().get_first_node_in_group("player") as Node3D
	
	movement_component.initialize(self, navigation_agent)
	
	if animation_tree:
		animation_tree.active = true
		animation_playback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	
	if health_component:
		health_component.died.connect(_on_died)
	
	setup_state_machine()

func setup_state_machine() -> void:
	state_machine = EnemyStateMachine.new()
	
	idle_state = EnemyIdleState.new()
	idle_state.enemy = self
	
	chase_state = EnemyChaseState.new()
	chase_state.enemy = self
	
	attack_state = EnemyAttackState.new()
	attack_state.enemy = self
	
	hit_state = EnemyHitState.new()
	hit_state.enemy = self
	
	death_state = EnemyDeathState.new()
	death_state.enemy = self
	
	state_machine.initialize(idle_state)

func _physics_process(delta: float) -> void:
	if is_dead:
		state_machine.physics_update(delta)
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	
	state_machine.physics_update(delta)
	state_machine.update(delta)
	move_and_slide()
	
	movement_component.update()
	
	update_locomotion_animation()

func find_player() -> Node3D:
	var player = get_tree().get_first_node_in_group("player") as Node3D
	if not is_instance_valid(player):
		return null
	
	if global_position.distance_to(player.global_position) > detection_range:
		return null
	
	return player

func move_towards_position(destination: Vector3) -> void:
	movement_component.move_towards_position(destination)

func stop_movement() -> void:
	movement_component.stop_movement()

func update_locomotion_animation() -> void:
	if is_dead or is_attacking or  is_hit:
		return
	if ability and ability.is_active():
		return
	if not animation_playback:
		return
	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	
	if horizontal_speed > 0.1:
		play_animation("walk")
	else:
		play_animation("idle")

func play_animation(animation_name: String) -> void:
	if is_attacking:
		return
	
	if ability and ability.is_active():
		return
	
	if not animation_playback:
		return
	
	if animation_playback.get_current_node() != animation_name:
		animation_playback.travel(animation_name)

func take_damage(amount: float) -> void:
	if not health_component or is_dead:
		return
	
	health_component.take_damage(amount)
	
	if is_dead:
		return
	
	state_machine.change_state(hit_state)

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
	is_attacking = false
	is_hit = false
	
	stop_movement()
	state_machine.change_state(death_state)

func get_attack_range() -> float:
	return 0.0

func start_attack() -> void:
	pass
