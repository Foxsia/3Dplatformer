class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	player.play_animation("idle")

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.jumps_left > 0:
		player.state_machine.change_state(player.jump_state)
		return
	
	if not player.is_on_floor():
		player.state_machine.change_state(player.fall_state)
		return
	
	if player.is_moving():
		if player.is_running:
			player.state_machine.change_state(player.run_state)
		else:
			player.state_machine.change_state(player.walk_state)
		return
