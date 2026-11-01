#include "enemy_movement_component.h"
#include <godot_cpp/classes/project_settings.hpp>

namespace godot
{
	void EnemyMovementComponent::_bind_methods()
	{
        ClassDB::bind_method(
            D_METHOD("initialize", "body", "navigation_agent"),
            &EnemyMovementComponent::initialize
        );

        ClassDB::bind_method(
            D_METHOD("move_towards_position", "destination"),
            &EnemyMovementComponent::move_towards_position
        );

        ClassDB::bind_method(
            D_METHOD("stop_movement"),
            &EnemyMovementComponent::stop_movement
        );

        ClassDB::bind_method(
            D_METHOD("jump_to_position", "destination"),
            &EnemyMovementComponent::jump_to_position
        );

        ClassDB::bind_method(
            D_METHOD("update"),
            &EnemyMovementComponent::update
        );

        ClassDB::bind_method(
            D_METHOD("is_moving"),
            &EnemyMovementComponent::is_moving
        );

        ClassDB::bind_method(
            D_METHOD("get_is_jumping"),
            &EnemyMovementComponent::get_is_jumping
        );

        ClassDB::bind_method(
            D_METHOD("set_move_speed", "value"),
            &EnemyMovementComponent::set_move_speed
        );

        ClassDB::bind_method(
            D_METHOD("get_move_speed"),
            &EnemyMovementComponent::get_move_speed
        );

        ClassDB::bind_method(
            D_METHOD("set_jump_duration", "value"),
            &EnemyMovementComponent::set_jump_duration
        );

        ClassDB::bind_method(
            D_METHOD("get_jump_duration"),
            &EnemyMovementComponent::get_jump_duration
        );

        ClassDB::bind_method(
            D_METHOD("set_gravity", "value"),
            &EnemyMovementComponent::set_gravity
        );

        ClassDB::bind_method(
            D_METHOD("get_gravity"),
            &EnemyMovementComponent::get_gravity
        );

        ClassDB::bind_method(
            D_METHOD("_on_navigation_link_reached", "details"),
            &EnemyMovementComponent::_on_navigation_link_reached
        );

        ADD_PROPERTY(
            PropertyInfo(Variant::FLOAT, "move_speed"),
            "set_move_speed",
            "get_move_speed"
        );

        ADD_PROPERTY(
            PropertyInfo(Variant::FLOAT, "jump_duration"),
            "set_jump_duration",
            "get_jump_duration"
        );

        ADD_PROPERTY(
            PropertyInfo(Variant::FLOAT, "gravity"),
            "set_gravity",
            "get_gravity"
        );
	}
	void EnemyMovementComponent::initialize(CharacterBody3D* _body, NavigationAgent3D* _navigation_agent)
	{
        body = _body;
        navigation_agent = _navigation_agent;

        if (!navigation_agent->is_connected("link_reached", Callable(this, "_on_navigation_link_reached")))
        {
            navigation_agent->connect("link_reached", Callable(this, "_on_navigation_link_reached"));
        }

        Variant gravity_setting = ProjectSettings::get_singleton()->get_setting("physics/3d/default_gravity");

        gravity = (double)gravity_setting;
	}
	void EnemyMovementComponent::move_towards_position(Vector3 destination)
	{
        if (!body || !navigation_agent || is_jumping) return;

        if (navigation_agent->get_target_position().distance_to(destination) > 0.5)
        {
            navigation_agent->set_target_position(destination);
        }

        if (navigation_agent->is_navigation_finished())
        {
            stop_movement();
            return;
        }

        Vector3 next_position = navigation_agent->get_next_path_position();

        if (is_jumping) return;

        Vector3 direction = next_position - body->get_global_position();
        direction.y = 0.0;

        if (direction.length_squared() < 0.04)
        {
            stop_movement();
            return;
        }

        direction = direction.normalized();
        Vector3 velocity = body->get_velocity();

        velocity.x = direction.x * move_speed;
        velocity.z = direction.z * move_speed;

        body->set_velocity(velocity);

        wants_to_move = true;
	}
	void EnemyMovementComponent::stop_movement()
	{
        if (!body) {
            return;
        }

        Vector3 velocity = body->get_velocity();

        velocity.x = 0.0;
        velocity.z = 0.0;

        body->set_velocity(velocity);

        wants_to_move = false;
	}
	void EnemyMovementComponent::jump_to_position(Vector3 destination)
	{
        if (!body || is_jumping) {
            return;
        }

        Vector3 jump_direction = destination - body->get_global_position();

        Vector3 horizontal_direction(
            jump_direction.x,
            0.0,
            jump_direction.z
        );

        double horizontal_distance = horizontal_direction.length();

        if (horizontal_distance < 0.1) {
            return;
        }

        double duration = MAX(
            horizontal_distance / move_speed,
            jump_duration
        );

        duration = CLAMP(duration, 0.2, 1.0);

        Vector3 velocity = body->get_velocity();

        velocity.x = horizontal_direction.x / duration;
        velocity.z = horizontal_direction.z / duration;

        velocity.y = (
            jump_direction.y +
            0.5 * gravity * duration * duration
            ) / duration;

        body->set_velocity(velocity);

        is_jumping = true;
        has_left_floor = false;
        wants_to_move = false;
	}
	void EnemyMovementComponent::update()
	{
        if (!body || !is_jumping) return;
        if (!body->is_on_floor()) has_left_floor = true;

        if (has_left_floor && body->is_on_floor())
        {
            is_jumping = false;
            has_left_floor = false;
            wants_to_move = false;
        }
	}
	bool EnemyMovementComponent::is_moving() const
	{
		return wants_to_move;
	}
	bool EnemyMovementComponent::get_is_jumping() const
	{
		return is_jumping;
	}
	void EnemyMovementComponent::set_move_speed(double value)
	{
        move_speed = MAX(value, 0.0);
	}
	double EnemyMovementComponent::get_move_speed() const
	{
		return move_speed;
	}
	void EnemyMovementComponent::set_jump_duration(double value)
	{
        jump_duration = MAX(value, 0.1);
	}
	double EnemyMovementComponent::get_jump_duration() const
	{
		return jump_duration;
	}
	void EnemyMovementComponent::set_gravity(double value)
	{
        gravity = MAX(value, 0.0);
	}
	double EnemyMovementComponent::get_gravity() const
	{
		return gravity;
	}
	void EnemyMovementComponent::_on_navigation_link_reached(Dictionary details)
	{
        if (is_jumping) return;

        if (!details.has("link_exit_position")) return;

        Vector3 exit_position = details["link_exit_position"];

        jump_to_position(exit_position);
	}
}