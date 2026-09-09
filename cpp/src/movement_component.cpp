#include "movement_component.h"

namespace godot {

	void MovementComponent::_bind_methods()
	{
		ClassDB::bind_method(
			D_METHOD("set_speed", "value"),
			&MovementComponent::set_speed
		);

		ClassDB::bind_method(
			D_METHOD("get_speed"),
			&MovementComponent::get_speed
		);

		ClassDB::bind_method(
			D_METHOD("set_sprint_multiplier", "value"),
			&MovementComponent::set_sprint_multiplier
		);

		ClassDB::bind_method(
			D_METHOD("get_sprint_multiplier"),
			&MovementComponent::get_sprint_multiplier
		);

		ClassDB::bind_method(
			D_METHOD("calculate_velocity", "direction", "sprinting"),
			&MovementComponent::calculate_velocity
		);

		ADD_PROPERTY(
			PropertyInfo(Variant::FLOAT, "speed"),
			"set_speed",
			"get_speed"
		);

		ADD_PROPERTY(
			PropertyInfo(Variant::FLOAT, "sprint_multiplier"),
			"set_sprint_multiplier",
			"get_sprint_multiplier"
		);
	}

	void MovementComponent::set_speed(float value)
	{
		speed = value;
	}

	float MovementComponent::get_speed() const
	{
		return speed;
	}

	void MovementComponent::set_sprint_multiplier(float value)
	{
		sprint_multiplier = value;
	}

	float MovementComponent::get_sprint_multiplier() const
	{
		return sprint_multiplier;
	}

	Vector3 MovementComponent::calculate_velocity(Vector3 direction, bool sprinting) const
	{
		float multiplier = sprinting ? sprint_multiplier : 1.0f;
		return direction * speed * multiplier;
	}

}