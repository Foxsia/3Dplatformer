extends Ability

@export var slam_speed := 30.0
@export var damage := 25.0
@export var damage_radius := 4.0

var player: CharacterBody3D

func _ready() -> void:
	player = get_parent()

func _can_activate() -> bool:
	return not player.is_on_floor()

func _on_activate():
	player.velocity.y = -slam_speed

func _on_update(delta):
	player.velocity.y = -slam_speed

	if player.is_on_floor():
		deal_damage()
		finish()

func deal_damage():
	var space_state = player.get_world_3d().direct_space_state

	var query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()

	sphere.radius = damage_radius
	query.shape = sphere
	query.transform = Transform3D(
		Basis(),
		player.global_position
	)

	query.collision_mask = 2

	var results = space_state.intersect_shape(query)

	for result in results:
		var target = result["collider"]

		if target.has_method("take_damage"):
			target.take_damage(damage)
