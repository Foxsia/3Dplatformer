#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/array.hpp>

namespace godot
{
	class Ability;

	class AbilitySystem : public Node
	{
		GDCLASS(AbilitySystem, Node);

	protected:
		static void _bind_methods();

	public:
		void _ready();
		void _process(double delta);

		void register_ability(Ability* ability);
		bool request_activation(Ability* ability);
		bool can_activate(Ability* ability) const;
		void update(double delta);

		Array get_abilities() const;
	private:
		Vector<Ability*> abilities;

		bool has_conflict(Ability* ability) const;
		bool is_movement_locked() const;
	};
}