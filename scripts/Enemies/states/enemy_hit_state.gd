class_name EnemyHitState
extends EnemyState

var hit_duration := 0.4
var timer := 0.0

func enter() -> void:
	timer = 0.0
	enemy.velocity.x = 0.0
	enemy.velocity.z = 0.0
	enemy.play_animation("hit")

func physics_update(_delta: float) -> void:
	timer += _delta
	
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 30.0 * _delta)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0.0, 30.0 * _delta)
	if timer >= hit_duration:
		if not enemy.is_on_floor():
			enemy.state_machine.change_state(enemy.fall_state)
		else:
			enemy.state_machine.change_state(enemy.idle_state)
