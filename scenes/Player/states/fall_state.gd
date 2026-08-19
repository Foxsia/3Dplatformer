class_name PlayerFallState
extends PlayerState

func enter() -> void:
	player.play_animation("static")

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		player.jumps_left = player.MAX_JUMPS
		if player.is_moving():
			if player.is_running:
				player.state_machine.change_state(player.run_state)
			else:
				player.state_machine.change_state(player.walk_state)
		else:
			player.state_machine.change_state(player.idle_state)
