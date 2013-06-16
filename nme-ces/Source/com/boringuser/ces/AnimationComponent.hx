package com.boringuser.ces;

/**
 * Specifies the AnimationSequence and current frame in that sequence for an entity.
 */
class AnimationComponent
{
    public var animationSequence (default, null) : AnimationSequence;
    public var currentFrame (default, default) : Int;

    private var animationLoader : AnimationLoader;

    public function new (animationLoader : AnimationLoader)
    {
        this.animationLoader = animationLoader;
        this.currentFrame = 0;
    }

    public function setAnimationSequenceName(name : String) : Void
    {
        // only set a new sequence if we don't have a sequence or if the existing one is different
        if (this.animationSequence == null || this.animationSequence.name != name) {
            this.animationSequence = this.animationLoader.getAnimationSequences().get(name);
        }
    }
}