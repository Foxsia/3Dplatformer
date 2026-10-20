class_name EnemyChaseState
extends EnemyState

func enter() -> void:
	pass

func physics_update(_delta: float) -> void:
	var target := enemy.find_player()
	
	if not target:
		enemy.state_machine.change_state(enemy.idle_state)
		return
	
	enemy.target = target
	enemy.face_target(target)
	
	var distance := enemy.global_position.distance_to(
		target.global_position
	)
	
	if distance <= enemy.get_attack_range():
		enemy.stop_movement()
		enemy.state_machine.change_state(enemy.attack_state)
		return
	
	enemy.move_towards_position(target.global_position)
