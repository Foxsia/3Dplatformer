#pragma once

#include <godot_cpp/classes/node.hpp>

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

	private:
		Vector<Ability*> abilities;
	};
}