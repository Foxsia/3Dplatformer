# Patrol Component Definition

## Properties
- reach_distance: float

## Methods
- get_direction_to_target(current_position, target_position) -> Vector3
- has_reached_target(current_position, target_position) -> bool

## Signals
- None

## Boundaries

### C++:

- Calculates patrol direction
- Checks distance to target
- Stores reach_distance

### GDScript:

- Selects patrol targets
- Switches between patrol points
- Handles movement, gravity and animations
- Handles player interaction

## The C++ component does not know about the Enemy or its scene