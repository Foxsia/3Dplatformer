extends Node

var rings = 0

signal rings_changed(rings)

func add_ring():
	rings += 1
	rings_changed.emit(rings)

var current_level := 1
var unlocked_levels := 1

func unlock_level(level: int):
	if level > unlocked_levels:
		unlocked_levels = level

func is_level_unlocked(level: int) -> bool:
	return level <= unlocked_levels

func complete_level(level: int):
	unlock_level(level + 1)
	current_level = level + 1
