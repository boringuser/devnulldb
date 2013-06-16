package com.boringuser.ces;

/**
 * An animation sequence specifies the integer IDs of frames in a named animation.
 */
class AnimationSequence
{
    public function new(name : String, frameIds : Array<Int>)
    {
        this.name = name;
        this.frameIds = frameIds;
    }

    public var name (default, null) : String;
    public var frameIds (default, null) : Array<Int>;
}