class_name PlayerJumpState
extends PlayerState

func enter() -> void:
	player.velocity.y = player.JUMP_VELOCITY
	player.jumps_left -= 1
	player.play_animation("gesture-positive")

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.jumps_left > 0:
		player.velocity.y = player.JUMP_VELOCITY
		player.jumps_left -= 1
		return

	if player.velocity.y < 0:
		player.state_machine.change_state(player.fall_state)
