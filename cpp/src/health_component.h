#pragma once
#include <godot_cpp/classes/node.hpp>

using namespace godot;

class HealthComponent : public Node {
	GDCLASS(HealthComponent, Node);

protected:
	static void _bind_methods();

public:
	void take_damage(float amount);
	float get_health() const;

private:
	float health = 100.0f;
};
