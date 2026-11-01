#pragma once
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/navigation_agent3d.hpp>
#include <godot_cpp/variant/vector3.hpp>

namespace godot
{
	class EnemyMovementComponent : public Node {
		GDCLASS(EnemyMovementComponent, Node)

	protected:
		static void _bind_methods();

	public:
		EnemyMovementComponent() = default;
		~EnemyMovementComponent() = default;

		void initialize(
			CharacterBody3D *_body,
			NavigationAgent3D *_navigation_agent
		);

		void move_towards_position(Vector3 destination);
		void stop_movement();
		void jump_to_position(Vector3 destination);

		void update();

		bool is_moving() const;

		bool get_is_jumping() const;

		void set_move_speed(double value);
		double get_move_speed() const;

		void set_jump_duration(double value);
		double get_jump_duration() const;

		void set_gravity(double value);
		double get_gravity() const;

	private:
		CharacterBody3D* body = nullptr;
		NavigationAgent3D* navigation_agent = nullptr;

		double move_speed = 2.5;
		double jump_duration = 0.5;
		double gravity = 9.8;

		bool is_jumping = false;
		bool has_left_floor = false;
		bool wants_to_move = false;

		Vector3 jump_end_position;

		void _on_navigation_link_reached(Dictionary details);
	};
}