class_name EnemyAttackState
extends EnemyState

func enter() -> void:
	enemy.stop_movement()
	enemy.is_attacking = false
	enemy.start_attack()

func physics_update(_delta: float) -> void:
	var target := enemy.find_player()
	
	if not target:
		enemy.state_machine.change_state(enemy.idle_state)
		return
	
	enemy.face_target(target)
	
	var distance := enemy.global_position.distance_to(
		target.global_position
	)
	
	if distance > enemy.get_attack_range():
		enemy.state_machine.change_state(enemy.chase_state)
	
	if not enemy.is_attacking:
		enemy.start_attack()
