#pragma once
#include <godot_cpp/classes/node.hpp>

namespace godot
{
	class Ability : public Node 
	{
		GDCLASS(Ability, Node);

	public:
		enum State { READY, ACTIVE, COOLDOWN };

		Ability() = default;
		~Ability() = default;

		virtual bool can_activate();
		virtual void activate();
		virtual void finish();
		virtual void physics_update(double delta);

		bool is_active() const;
		bool is_on_cooldown() const;
		Ability::State get_state() const;

		void set_cooldown(double duration);
		double get_cooldown() const;

		double get_cooldown_remaining() const;

	protected:
		static void _bind_methods();

		State state = READY;
		double cooldown_duration = 0.0;
		double cooldown_remaining = 0.0;
	};
}