#include "ability.h"
#include <godot_cpp/core/class_db.hpp>

namespace godot
{
	void Ability::_bind_methods()
	{
        ClassDB::bind_method(D_METHOD("can_activate"), &Ability::can_activate);
        ClassDB::bind_method(D_METHOD("activate"), &Ability::activate);
        ClassDB::bind_method(D_METHOD("finish"), &Ability::finish);
        ClassDB::bind_method(D_METHOD("update", "delta"), &Ability::update);

        ClassDB::bind_method(D_METHOD("is_active"), &Ability::is_active);
        ClassDB::bind_method(D_METHOD("is_on_cooldown"), &Ability::is_on_cooldown);

        ClassDB::bind_method(D_METHOD("set_cooldown", "duration"), &Ability::set_cooldown);
        ClassDB::bind_method(D_METHOD("get_cooldown"), &Ability::get_cooldown);
        ClassDB::bind_method(
            D_METHOD("get_cooldown_remaining"),
            &Ability::get_cooldown_remaining
        );

        ADD_PROPERTY(
            PropertyInfo(Variant::FLOAT, "cooldown"),
            "set_cooldown",
            "get_cooldown"
        );

        GDVIRTUAL_BIND(_on_activate);
        GDVIRTUAL_BIND(_on_update);
	}

    bool Ability::can_activate()
    {
        return state == READY;
    }

    void Ability::activate()
    {
        if (!can_activate()) return;
        state = ACTIVE;

        GDVIRTUAL_CALL(_on_activate);
    }

    void Ability::finish()
    {
        if (state != ACTIVE) return;
        if (cooldown_duration > 0.0)
        {
            state = COOLDOWN;
            cooldown_remaining = cooldown_duration;
        }
        else
        {
            state = READY;
        }
    }

    void Ability::update(double delta)
    {
        if (state == COOLDOWN)
        {
            cooldown_remaining -= delta;
            if (cooldown_remaining <= 0.0)
            {
                cooldown_remaining = 0.0;
                state = READY;
            }
        }

        if (state == ACTIVE)
        {
            GDVIRTUAL_CALL(_on_update, delta);
        }
    }

    bool Ability::is_active() const
    {
        return state == ACTIVE;
    }

    bool Ability::is_on_cooldown() const
    {
        return state == COOLDOWN;
    }

    Ability::State Ability::get_state() const
    {
        return state;
    }

    void Ability::set_cooldown(double duration)
    {
        cooldown_duration = MAX(0.0, duration);
    }

    double Ability::get_cooldown() const
    {
        return cooldown_duration;
    }

    double Ability::get_cooldown_remaining() const
    {
        return cooldown_remaining;
    }

}