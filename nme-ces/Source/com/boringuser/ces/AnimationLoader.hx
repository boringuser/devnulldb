package com.boringuser.ces;

import nme.display.BitmapData;
import nme.geom.Rectangle;

/**
 * An interface for loading animation data from some source. The bitmap data is sliced into frame rects, and the
 * animation sequences specify each frame rect, in order, for a given animation.
 */
interface AnimationLoader
{
    function getBitmapData () : BitmapData;

    function getFrameRects () : Array<Rectangle>;

    function getAnimationSequences() : Hash<AnimationSequence>;
}