class_name EnemyIdleState
extends EnemyState

func enter() -> void:
	enemy.stop_movement()
	enemy.play_animation("idle")

func physics_update(_delta: float) -> void:
	var target := enemy.find_player()

	if target:
		enemy.target = target
		enemy.state_machine.change_state(enemy.chase_state)
