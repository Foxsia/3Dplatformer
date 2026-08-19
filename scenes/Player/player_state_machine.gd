class_name PlayerStateMachine
extends RefCounted

var current_state: PlayerState

func initialize(start_state: PlayerState) -> void:
	current_state = start_state
	current_state.enter()

func change_state(new_state: PlayerState) -> void:
	if current_state == new_state:
		return
	
	current_state.exit()
	current_state = new_state
	current_state.enter()

func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)
