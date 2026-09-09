#pragma once
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/vector3.hpp>

namespace godot
{
	class MovementComponent : public Node {
		GDCLASS(MovementComponent, Node);

	protected:
		static void _bind_methods();

	public:
		void set_speed(float value);
		float get_speed() const;

		void set_sprint_multiplier(float value);
		float get_sprint_multiplier() const;

		Vector3 calculate_velocity(Vector3 direction, bool sprinting) const;

	private:
		float sprint_multiplier = 2.0f;
		float speed = 5.0f;
	};
}