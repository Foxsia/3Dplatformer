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

        ClassDB::bind_method(
            D_METHOD("has_conflict"),
            &AbilitySystem::has_conflict
        );

        ClassDB::bind_method(
            D_METHOD("is_movement_locked"),
            &AbilitySystem::is_movement_locked
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
        if (!ability->can_activate()) return false;
        if (has_conflict(ability)) return false;
        return true;
    }

    void AbilitySystem::update(double delta)
    {
        for (Ability* ability : abilities)
        {
            if (!ability) continue;

            ability->update(delta);
        }
    }
    bool AbilitySystem::has_conflict(Ability* ability) const
    {
        if (!ability) return false;

        String group = ability->get_conflict_group();

        if (group.is_empty()) return false;

        for (Ability* other : abilities)
        {
            if (!other || other == ability) continue;

            if (!other->is_active()) continue;

            if (other->get_conflict_group() == group) return true;
        }

        return false;
    }
    bool AbilitySystem::is_movement_locked() const
    {
        for(Ability * ability : abilities)
        {
            if (!ability) continue;

            if (!ability->is_active()) continue;

            if (ability->get_conflict_group() == "movement") return true;
        }

        return false;
    }
}