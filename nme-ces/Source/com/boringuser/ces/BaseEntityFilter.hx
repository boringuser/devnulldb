package com.boringuser.ces;

/**
 * An entity filter that maintains a reference to a Simulation. Accepts all entities (does not filter anything).
 */
class BaseEntityFilter implements EntityFilter
{
    public function new () {}

    public function filter (entityName : String) : Bool
    {
        return true;
    }
}