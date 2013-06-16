package com.boringuser.ces;

/**
 * An entity filter that requires a specified set of component types to be attached to an entity.
 */
class RequiredEntityFilter extends BaseEntityFilter
{
    private var requiredComponentClasses : Array<Class<Dynamic>>;

    public function new (requiredComponentClasses : Array<Class<Dynamic>>)
    {
        super();

        this.requiredComponentClasses = requiredComponentClasses;
    }

    public override function filter (entityName : String) : Bool
    {
        for (requiredComponentClass in this.requiredComponentClasses) {
            if (!Simulation.hasComponent(requiredComponentClass, entityName)) {
                return false;
            }
        }

        return true;
    }
}