package com.boringuser.ces;

/** 
 * Systems are updated every frame.
 */
interface System
{
    /**
     * Called when the set of components attached to an entity changes.
     */
    function notifyEntityChanged (entityName : String) : Void;

    /**
     * Called when an entity is deleted from the simulation.
     */
    function notifyEntityDeleted (entityName : String) : Void;

    /**
     * Called each frame.
     */
    function update () : Void;
}