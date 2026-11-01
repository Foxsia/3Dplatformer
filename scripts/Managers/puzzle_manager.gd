extends Node

@export var gate: AnimatableBody3D
@export var panda: Node

var activated_buttons := 0
var puzzle_completed := false

func button_activated():
	if puzzle_completed:
		return
	
	activated_buttons += 1
	
	if activated_buttons >= 2:
		puzzle_completed = true
		if gate != null:
			gate.open()
		if panda != null:
			panda.puzzle_completed = true
