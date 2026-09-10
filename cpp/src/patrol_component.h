#pragma once
#include <godot_cpp/classes/node.hpp>

namespace godot {
	class PatrolComponent : public Node {
		GDCLASS(PatrolComponent, Node)

	private:
		float reach_distance = 0.5f;
	protected:
		static void _bind_methods();
	public:
		PatrolComponent();
		Vector3 get_direction_to_target(
			Vector3 current_position,
			Vector3 target_position
		) const;

		bool has_reached_target(
			Vector3 current_position,
			Vector3 target_position
		) const;

		void set_reach_distance(float value);
		float get_reach_distance() const;
	};
}