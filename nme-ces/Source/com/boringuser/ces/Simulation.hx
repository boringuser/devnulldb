package com.boringuser.ces;

import haxe.FastList;

/**
 * The simulation manages all entities, components and systems. Components should be added first, followed by systems.
 * Finally, entities should be created and components should be added to entities. The simulation's update method should
 * be invoked on each frame.
 */
class Simulation
{
    // entities, each having components
    private static var ENTITIES : Hash<Hash<Dynamic>> = new Hash<Hash<Dynamic>>();

    // registered systems
    private static var SYSTEMS : FastList<System> = new FastList<System>();

    /**
     * Should be called each frame to update systems in the simulation.
     */
    public static function update () : Void
    {
        for (system in SYSTEMS) {
            system.update();
        }
    }

    /**
     * Adds a system for processing entities. Idempotent.
     */
    public static function addSystem (system : System) : Void
    {
        SYSTEMS.remove(system);
        SYSTEMS.add(system);
    }

    /**
     * Removes a system, or throws if the system is not added.
     */
    public static function removeSystem (system : System) : Void
    {
        if (!SYSTEMS.remove(system)) {
            throw(system + " was not added");
        }
    }

    public static function removeAllSystems () : Void
    {
        SYSTEMS = new FastList<System>();
    }

    /**
     * Creates a new entity in the simulation. Throws if an entity with the provided name already exists.
     */
    public static function createEntity (entityName : String) : Void
    {
        if (ENTITIES.exists(entityName)) {
            throw("entity " + entityName + " already exists");
        }

        ENTITIES.set(entityName, new Hash<Dynamic>());
    }

    /**
     * Throws if the specified entity name is not legitimate.
     */
    private static function validateEntityExists (entityName : String) : Void
    {
        if (!ENTITIES.exists(entityName)) {
            throw(entityName + " is not a valid entity name");
        }
    }

    /**
     * Removes an entity from the simulation. Throws if the entity does not exist.
     */
    public static function deleteEntity (entityName : String) : Void
    {
        validateEntityExists(entityName);

        ENTITIES.remove(entityName);

        for (system in SYSTEMS) {
            system.notifyEntityDeleted(entityName);
        }
    }

    /**
     * Updates attached systems about the fact the set of components attached to
     * an entity has changed.
     */
    private static function notifySystemsOfEntityChange (entityName : String)
    {
        for (system in SYSTEMS) {
            system.notifyEntityChanged(entityName);
        }
    }

    /**
     * Returns true if the specified entity has the specified component type attached. Throws if the entity does not
     * exist.
     */
    public static function hasComponent (componentClass : Class<Dynamic>, entityName : String) : Bool
    {
        validateEntityExists(entityName);

        var componentClassName : String = TypeUtil.getClassNameForClass(componentClass);

        return ENTITIES.get(entityName).exists(componentClassName);
    }
    /**
     * Returns the specified component attached to the specified entity. Throws if the component type does not exist, if
     * the component is not attached to the entity, or if the entity does not exist.
     */
    public static function getComponent<T> (componentClass : Class<Dynamic>, entityName : String) : T
    {
        validateEntityExists(entityName);

        var componentClassName : String = TypeUtil.getClassNameForClass(componentClass);
        var component : Dynamic = ENTITIES.get(entityName).get(componentClassName);
        
        if (component == null) {
            throw(componentClassName + " is not attached to the specified entity");
        }

        return component;
    }

    /**
     * Adds a component to an entity. If the entity already has a component of the same type it will be replaced. Throws
     * if the entity does not exist.
     */
    public static function addComponentToEntity (component : Dynamic, entityName : String) : Void
    {
        validateEntityExists(entityName);

        var componentClassName : String = TypeUtil.getClassNameForInstance(component);

        ENTITIES.get(entityName).set(componentClassName, component);

        notifySystemsOfEntityChange(entityName);
    }
}