extends Node

var rings = 0

signal rings_changed(rings)

func add_ring():
	rings += 1
	rings_changed.emit(rings)
