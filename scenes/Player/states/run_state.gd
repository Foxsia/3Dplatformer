class_name PlayerRunState
extends PlayerState

func enter() -> void:
	player.play_animation("run")

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		player.state_machine.change_state(player.fall_state)
		return

	if Input.is_action_just_pressed("jump"):
		player.state_machine.change_state(player.jump_state)
		return

	if not player.is_moving():
		player.state_machine.change_state(player.idle_state)
		return

	if not player.is_running:
		player.state_machine.change_state(player.walk_state)
