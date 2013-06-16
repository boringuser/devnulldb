package com.boringuser.ces;

import haxe.FastList;

/**
 * A base implementation of System that maintains a reference to a Simulation and uses EntityFilters to manage a set of
 * entities when it recieves entity change/delete notifications.
 */
class BaseSystem implements System
{
    private var entityNames (default, default) : FastList<String>;
    private var entityFilters : Array<EntityFilter>;

    public function new ()
    {
        this.entityFilters = new Array<EntityFilter>();
        this.entityNames = new FastList<String>();
    }

    public function notifyEntityChanged (entityName : String) : Void
    {
        this.entityNames.remove(entityName);

        for (filter in this.entityFilters) {
            if (!filter.filter(entityName)) {
                return;
            }
        }

        this.entityNames.add(entityName);
    }

    public function notifyEntityDeleted (entityName : String) : Void
    {
        this.entityNames.remove(entityName);
    }

    public function update () : Void {}
}