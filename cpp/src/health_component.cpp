#include "health_component.h"

namespace godot 
{

	void HealthComponent::_bind_methods() {
		ADD_SIGNAL(MethodInfo(
			"lives_changed",
			PropertyInfo(Variant::INT, "new_lives")
		));

		ClassDB::bind_method(
			D_METHOD("lose_life"),
			&HealthComponent::lose_life);

		ClassDB::bind_method(
			D_METHOD("get_lives"),
			&HealthComponent::get_lives);

		ClassDB::bind_method(
			D_METHOD("set_max_lives", "value"),
			&HealthComponent::set_max_lives
		);

		ClassDB::bind_method(
			D_METHOD("get_max_lives"),
			&HealthComponent::get_max_lives
		);

		ADD_PROPERTY(
			PropertyInfo(Variant::INT, "max_lives"),
			"set_max_lives",
			"get_max_lives"
		);
	}

	void HealthComponent::_ready()
	{
		lives = max_lives;
	}

	void HealthComponent::lose_life() {
		if (lives > 0)
		{
			lives -= 1;
			emit_signal("lives_changed", static_cast<int>(lives));
		}
	}

	int HealthComponent::get_lives() const {
		return lives;
	}

	void HealthComponent::set_max_lives(int value)
	{
		max_lives = value;
	}

	int HealthComponent::get_max_lives() const
	{
		return max_lives;
	}
}