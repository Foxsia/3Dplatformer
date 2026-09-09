#include "health_component.h"

using namespace godot;

void HealthComponent::_bind_methods() {
	ClassDB::bind_method(
			D_METHOD("take_damage", "amount"),
			&HealthComponent::take_damage);

	ClassDB::bind_method(
			D_METHOD("get_health"),
			&HealthComponent::get_health);
}

void HealthComponent::take_damage(float amount) {
	health -= amount;

	if (health < 0.0f) {
		health = 0.0f;
	}

	print_line("Health: " + String::num(health));
}

float HealthComponent::get_health() const {
	return health;
}
