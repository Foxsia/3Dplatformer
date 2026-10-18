extends Node
class_name EnemyBase

@export var move_speed := 2.5
@export var gravity := 9.8
@export var detencion_range : = 15.0
@export var attack_range := 2.0

@export var visual_root: Node3D
@export var animation_tree: AnimationTree
@export var navigation_agent: NavigationAgent3D
@export var health_component: HealthComponent

var target: Node3D
var animation_playback
var is_dead := false

func _ready() -> void:
	add_to_group("enemy")
	target.get_tree().get_first_node_in_group("player")
	
	if animation_tree:
		animation_tree.active = true
		animation_playback = animation_tree.get("parameters/playback")
	
	if health_component:
		health_component.died.connect(_on_died)

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

func _on_died() -> void:
	if is_dead:
		return
	
	is_dead = true
	queue_free()
