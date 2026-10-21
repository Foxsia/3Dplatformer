class_name PlayerHitState
extends PlayerState

var hit_duration := 0.4
var timer := 0.0

func enter() -> void:
	timer = 0.0
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	player.play_animation("hit")

func physics_update(_delta: float) -> void:
	timer += _delta
	
	player.velocity.x = move_toward(player.velocity.x, 0.0, 30.0 * _delta)
	player.velocity.z = move_toward(player.velocity.z, 0.0, 30.0 * _delta)
	if timer >= hit_duration:
		if not player.is_on_floor():
			player.state_machine.change_state(player.fall_state)
		else:
			player.state_machine.change_state(player.idle_state)
