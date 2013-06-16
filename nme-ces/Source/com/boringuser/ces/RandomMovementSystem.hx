package com.boringuser.ces;

/**
 * Randomly moves entities with a LocationComponent.
 */
class RandomMovementSystem extends BaseSystem
{
    public function new ()
    {
        super();

        // we're interested in any entity with a location component but no player character component
        this.entityFilters = [
            new RequiredEntityFilter([LocationComponent]),
            new ExcludedEntityFilter([PlayerCharacterComponent])
        ];
    }

    public override function update () : Void
    {
        for (entityName in this.entityNames) {
            var locationComponent : LocationComponent = Simulation.getComponent(LocationComponent, entityName);

            // move randomly
            var xoff : Int = Std.random(2);
            var yoff : Int = Std.random(2);

            if (Std.random(10) % 2 == 0) xoff *= -1;
            if (Std.random(10) % 2 == 0) yoff *= -1;

            locationComponent.xpos += xoff;
            locationComponent.ypos += yoff;

            // constrain location to the screen
            if (locationComponent.xpos > 479) locationComponent.xpos = 479;
            if (locationComponent.xpos < 0) locationComponent.xpos = 0;

            if (locationComponent.ypos > 319) locationComponent.ypos = 319;
            if (locationComponent.ypos < 0) locationComponent.ypos = 0;
        }
    }

}