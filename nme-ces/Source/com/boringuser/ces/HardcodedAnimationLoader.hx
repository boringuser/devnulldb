package com.boringuser.ces;

import nme.Assets;
import nme.display.BitmapData;
import nme.geom.Rectangle;

/**
 * For testing purposes until we have a file-based mechanism.
 */
class HardcodedAnimationLoader implements AnimationLoader
{
    public function new () {}
    
    public function getBitmapData () : BitmapData
    {
        return Assets.getBitmapData("images/chef.png");
    }

    public function getFrameRects () : Array<Rectangle>
    {
        return [new Rectangle(4, 0, 8, 16), new Rectangle(20, 0, 8, 16)];
    }

    public function getAnimationSequences() : Hash<AnimationSequence>
    {
        var animationSequences : Hash<AnimationSequence> = new Hash<AnimationSequence>();

        var animationSequence : AnimationSequence;

        animationSequence = new AnimationSequence("walking", [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1]);
        animationSequences.set(animationSequence.name, animationSequence);

        animationSequence = new AnimationSequence("standing", [0]);
        animationSequences.set(animationSequence.name, animationSequence);

        return animationSequences;
    }

}