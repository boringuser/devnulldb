package com.boringuser.ces;

import nme.events.KeyboardEvent;
import nme.Lib;

/**
 * A System that maintains a Buffer of keys pressed last frame and provides a mechanism for asking if any given key is
 * currently pressed.
 */
class KeyboardInputSystem implements System
{
    public var buffer (default, null) : Buffer<KeyboardEvent>;

    private var keysPressed : Array<Bool>;

    public function new ()
    {
        this.buffer = new Buffer<KeyboardEvent>();
        this.keysPressed = new Array<Bool>();

        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    // it would be nice to have things designed so that these empty methods are not necessary

    public function notifyEntityChanged (entityName : String) : Void {}
    public function notifyEntityDeleted (entityName : String) : Void {}

    private function onKeyDown (event : KeyboardEvent) : Void
    {
        this.buffer.add(event);
        this.keysPressed[event.keyCode] = true;
    }

    private function onKeyUp (event : KeyboardEvent) : Void
    {
        this.buffer.add(event);
        this.keysPressed[event.keyCode] = false;
    }

    /**
     * Returns true if the specified key code is currently pressed.
     */
    public function isPressed (keyCode : Int) : Bool
    {
        return this.keysPressed[keyCode];
    }

    // need to add wasPressed, timer stuff, etc... maybe find a way to abstract it so the same class can
    // be used for key/touch/mouse/etc events?

    public function update () : Void
    {
        buffer.mark();
    }
}