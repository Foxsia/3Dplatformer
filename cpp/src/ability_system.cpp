#include "ability_system.h"
#include "ability.h"

namespace godot
{
    void AbilitySystem::_bind_methods()
    {
        ClassDB::bind_method(
            D_METHOD("register_ability", "ability"),
            &AbilitySystem::register_ability
        );

        ClassDB::bind_method(
            D_METHOD("request_activation", "ability"),
            &AbilitySystem::request_activation
        );

        ClassDB::bind_method(
            D_METHOD("can_activate", "ability"),
            &AbilitySystem::can_activate
        );

        ClassDB::bind_method(
            D_METHOD("update", "delta"),
            &AbilitySystem::update
        );
    }

    void AbilitySystem::_ready()
    {
        set_process(true);
    }

    void AbilitySystem::_process(double delta)
    {
        update(delta);
    }

    void AbilitySystem::register_ability(Ability* ability)
    {
        if (!ability) return;
        if (abilities.has(ability)) return;
        abilities.push_back(ability);
    }

    bool AbilitySystem::request_activation(Ability* ability)
    {
        if (!can_activate(ability)) return false;
        ability->activate();
        return true;
    }

    bool AbilitySystem::can_activate(Ability* ability) const
    {
        if (!ability) return false;
        if (!abilities.has(ability)) return false;
        return ability->can_activate();
    }

    void AbilitySystem::update(double delta)
    {
        for (Ability* ability : abilities)
        {
            if (!ability) continue;

            ability->update(delta);
        }
    }
}