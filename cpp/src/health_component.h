#pragma once
#include <godot_cpp/classes/node.hpp>

namespace godot 
{

	class HealthComponent : public Node {
		GDCLASS(HealthComponent, Node);

	protected:
		static void _bind_methods();

	public:
		void lose_life();
		int get_lives() const;

		void set_max_lives(int value);
		int get_max_lives() const;
		virtual void _ready() override;

	private:
		int max_lives = 3;
		int lives = 3;
	};
}
