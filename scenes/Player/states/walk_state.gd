class_name PlayerWalkState
extends PlayerState

func enter() -> void:
	player.play_animation("walk")

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		player.state_machine.change_state(player.fall_state)
		return
	
	if Input.is_action_just_pressed("jump"):
		player.state_machine.change_state(player.jump_state)
	
	if not player.is_moving():
		player.state_machine.change_state(player.idle_state)
		return
	
	if player.is_running:
		player.state_machine.change_state(player.run_state)
