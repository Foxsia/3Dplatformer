#pragma once
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/gdvirtual.gen.inc>


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
		virtual void update(double delta);

		bool is_active() const;
		bool is_on_cooldown() const;
		Ability::State get_state() const;

		void set_cooldown(double duration);
		double get_cooldown() const;

		double get_cooldown_remaining() const;

		void set_conflict_group(const String& group);
		String get_conflict_group() const;

	protected:
		static void _bind_methods();

		GDVIRTUAL0RC(bool, _can_activate);
		GDVIRTUAL0(_on_activate);
		GDVIRTUAL1(_on_update, double);

		State state = READY;
		double cooldown_duration = 0.0;
		double cooldown_remaining = 0.0;

		String conflict_group;
	};
}