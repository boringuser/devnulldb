package com.boringuser.ces;

/**
 * An entity filter that rejects entities with any components in a specified set.
 */
class ExcludedEntityFilter extends BaseEntityFilter
{
    private var excludedComponentClasses : Array<Class<Dynamic>>;

    public function new (excludedComponentClasses : Array<Class<Dynamic>>)
    {
        super();

        this.excludedComponentClasses = excludedComponentClasses;
    }

    public override function filter (entityName : String) : Bool
    {
        for (excludedComponentClass in this.excludedComponentClasses) {
            if (Simulation.hasComponent(excludedComponentClass, entityName)) {
                return false;
            }
        }

        return true;
    }
}