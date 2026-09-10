#include "patrol_component.h"

#include <godot_cpp/core/class_db.hpp>

namespace godot {
	PatrolComponent::PatrolComponent() {
		reach_distance = 0.5f;
	}

    void PatrolComponent::_bind_methods() {

        ClassDB::bind_method(
            D_METHOD(
                "get_direction_to_target",
                "current_position",
                "target_position"
            ),
            &PatrolComponent::get_direction_to_target
        );

        ClassDB::bind_method(
            D_METHOD(
                "has_reached_target",
                "current_position",
                "target_position"
            ),
            &PatrolComponent::has_reached_target
        );

        ClassDB::bind_method(
            D_METHOD("set_reach_distance", "value"),
            &PatrolComponent::set_reach_distance
        );

        ClassDB::bind_method(
            D_METHOD("get_reach_distance"),
            &PatrolComponent::get_reach_distance
        );

        ADD_PROPERTY(
            PropertyInfo(
                Variant::FLOAT,
                "reach_distance"
            ),
            "set_reach_distance",
            "get_reach_distance"
        );
    }

    Vector3 PatrolComponent::get_direction_to_target(
        Vector3 current_position,
        Vector3 target_position
    ) const {
        Vector3 direction = current_position.direction_to(target_position);

        direction.y = 0.0f;

        return direction.normalized();
    }

    bool PatrolComponent::has_reached_target(
        Vector3 current_position,
        Vector3 target_position
    ) const {
        return current_position.distance_to(target_position) < reach_distance;
    }

    void PatrolComponent::set_reach_distance(float value) {
        reach_distance = value;
    }

    float PatrolComponent::get_reach_distance() const {
        return reach_distance;
    }
}