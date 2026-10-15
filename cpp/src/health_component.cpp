#include "health_component.h"

namespace godot 
{

	void HealthComponent::_bind_methods() {
		ADD_SIGNAL(MethodInfo(
			"lives_changed",
			PropertyInfo(Variant::INT, "new_lives")
		));

		ADD_SIGNAL(MethodInfo(
			"health_changed",
			PropertyInfo(Variant::FLOAT, "new_health"),
			PropertyInfo(Variant::FLOAT, "max_health")
		));

		ADD_SIGNAL(MethodInfo(
			"died"
		));

		ClassDB::bind_method(
			D_METHOD("take_damage", "amount"),
			&HealthComponent::take_damage
		);

		ClassDB::bind_method(
			D_METHOD("heal", "amount"),
			&HealthComponent::heal
		);

		ClassDB::bind_method(
			D_METHOD("get_health"),
			&HealthComponent::get_health
		);

		ClassDB::bind_method(
			D_METHOD("get_max_health"),
			&HealthComponent::get_max_health
		);

		ClassDB::bind_method(
			D_METHOD("set_max_health", "value"),
			&HealthComponent::set_max_health
		);

		ClassDB::bind_method(
			D_METHOD("is_dead"),
			&HealthComponent::is_dead
		);

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
			PropertyInfo(Variant::FLOAT, "max_health"),
			"set_max_health",
			"get_max_health"
		);

		ADD_PROPERTY(
			PropertyInfo(Variant::INT, "max_lives"),
			"set_max_lives",
			"get_max_lives"
		);
	}

	void HealthComponent::take_damage(double amount)
	{
		if (dead || amount <= 0.0) return;

		health = MAX(0.0, health - amount);

		emit_signal(
			"health_changed",
			health,
			max_health
		);

		if (health <= 0.0)
		{
			dead = true;
			emit_signal("died");
		}
	}

	void HealthComponent::heal(double amount)
	{
		if (dead || amount <= 0.0) return;

		health = MIN(max_health, health + amount);

		emit_signal(
			"health_changed",
			health,
			max_health
		);
	}

	double HealthComponent::get_health() const
	{
		return health;
	}

	double HealthComponent::get_max_health() const
	{
		return max_health;
	}

	void HealthComponent::set_max_health(double value)
	{
		max_health = MAX(1.0, value);
		health = MIN(health, max_health);

		if (health > 0.0) dead = false;
	}

	bool HealthComponent::is_dead() const
	{
		return dead;
	}

	void HealthComponent::_ready()
	{
		max_health = MAX(1.0, max_health);
		health = max_health;
		dead = false;

		max_lives = MAX(1, max_lives);
		lives = max_lives;

		emit_signal(
			"health_changed",
			health,
			max_health
		);
	}

	void HealthComponent::lose_life() 
	{
		if (lives > 0)
		{
			lives -= 1;
			emit_signal("lives_changed", static_cast<int>(lives));
		}
	}

	int HealthComponent::get_lives() const 
	{
		return lives;
	}

	void HealthComponent::set_max_lives(int value)
	{
		max_lives = MAX(1, value);
		lives = MIN(lives, max_lives);
	}

	int HealthComponent::get_max_lives() const
	{
		return max_lives;
	}
}