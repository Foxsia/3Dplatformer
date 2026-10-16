extends Ability

@export var damage := 20.0
@export var attack_duration := 0.7
@export var hit_start := 0.2
@export var hit_end := 0.45

@export var animation_tree_path: NodePath
@export var hitbox_path: NodePath

var player: CharacterBody3D
var animation_tree: AnimationTree
var hitbox: Area3D

var elapsed := 0.0
var hit_targets: Array[Node3D] = []

func _ready() -> void:
	player = get_parent() as CharacterBody3D
	animation_tree = get_node_or_null(animation_tree_path) as AnimationTree
	hitbox = get_node_or_null(hitbox_path) as Area3D
	
	if hitbox:
		hitbox.monitoring = false

func _can_activate() -> bool:
	return player != null and player.is_on_floor()

func _on_activate() -> void:
	elapsed = 0.0
	hit_targets.clear()
	
	if hitbox:
		hitbox.monitoring = false
	
	if animation_tree:
		var playback = animation_tree.get("parameters/playback")
		playback.start("attack")

func _on_update(delta: float) -> void:
	elapsed += delta
	
	if hitbox:
		var should_hit = elapsed >= hit_start and elapsed <= hit_end
		
		if hitbox.monitoring != should_hit:
			hitbox.monitoring = should_hit
		
		if should_hit:
			check_hits()
	
	if elapsed >= attack_duration:
		if hitbox:
			hitbox.monitoring = false
		finish()

func check_hits() -> void:
	if not hitbox:
		return
	
	for body in hitbox.get_overlapping_bodies():
		if body == player:
			continue
		
		if body in hit_targets:
			continue
		
		if body.has_method("take_damage"):
			hit_targets.append(body)
			body.take_damage(damage)
