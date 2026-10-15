#pragma once
#include <godot_cpp/classes/node.hpp>

namespace godot 
{

	class HealthComponent : public Node {
		GDCLASS(HealthComponent, Node);

	protected:
		static void _bind_methods();

	public:
		void take_damage(double amount);
		void heal(double amount);

		double get_health() const;
		double get_max_health() const;
		void set_max_health(double value);

		bool is_dead() const;

		void lose_life();
		int get_lives() const;

		void set_max_lives(int value);
		int get_max_lives() const;
		virtual void _ready() override;

	private:
		double max_health = 100.0;
		double health = 100.0;
		bool dead = false;

		int max_lives = 3;
		int lives = 3;
	};
}
