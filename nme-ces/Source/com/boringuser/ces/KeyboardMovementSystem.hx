package com.boringuser.ces;

/**
 * Moves the player character entity based on keyboard input.
 */
class KeyboardMovementSystem extends BaseSystem
{
    private var keyboardInputSystem : KeyboardInputSystem;

    public function new (keyboardInputSystem : KeyboardInputSystem)
    {
        super();

        this.keyboardInputSystem = keyboardInputSystem;

        this.entityFilters = [
            new RequiredEntityFilter([LocationComponent, PlayerCharacterComponent, AnimationComponent])
        ];
    }

    public override function update () : Void
    {
        for (entityName in this.entityNames) {
            var locationComponent : LocationComponent = Simulation.getComponent(LocationComponent, entityName);
            var animationComponent : AnimationComponent = Simulation.getComponent(AnimationComponent, entityName);

            var xoff : Int = 0;
            var yoff : Int = 0;
            var change : Int = 2;

            if (this.keyboardInputSystem.isPressed(37)) xoff -= change; // left
            if (this.keyboardInputSystem.isPressed(38)) yoff -= change; // up
            if (this.keyboardInputSystem.isPressed(39)) xoff += change; // right
            if (this.keyboardInputSystem.isPressed(40)) yoff += change; // down

            if (xoff != 0 || yoff != 0) {
                animationComponent.setAnimationSequenceName("walking");

                locationComponent.xpos += xoff;
                locationComponent.ypos += yoff;

                // constrain location to the screen
                if (locationComponent.xpos > 479) locationComponent.xpos = 479;
                if (locationComponent.xpos < 0) locationComponent.xpos = 0;

                if (locationComponent.ypos > 319) locationComponent.ypos = 319;
                if (locationComponent.ypos < 0) locationComponent.ypos = 0;
            } else {
                animationComponent.setAnimationSequenceName("standing");
            }
        }
    }

}