package com.boringuser.ces;

import nme.display.Graphics;
import nme.display.Tilesheet;
import nme.geom.Rectangle;

/**
 * This system animates entities which have both an animation and location component.
 */
class AnimationSystem implements haxe.rtti.Infos, extends BaseSystem
{
    private var tilesheet : Tilesheet;
    private var graphics : Graphics;

    public function new (graphics : Graphics, animationLoader : AnimationLoader)
    {
        super();

        this.graphics = graphics;
        this.tilesheet = new Tilesheet(animationLoader.getBitmapData());

        for (rect in animationLoader.getFrameRects()) {
            tilesheet.addTileRect(rect);
        }

        // this system cares about entities with location and animation components
        this.entityFilters = [
            new RequiredEntityFilter([LocationComponent, AnimationComponent])
        ];
    }

    public override function update () : Void
    {
        var tileData : Array<Float> = [];

        for (entityName in this.entityNames) {
            var locationComponent : LocationComponent = Simulation.getComponent(LocationComponent, entityName);
            var animationComponent : AnimationComponent = Simulation.getComponent(AnimationComponent, entityName);

            if (animationComponent.animationSequence == null) continue;
            
            // determine the current frame and increment it, cycling back to 0 if needed
            var frameId = animationComponent.animationSequence.frameIds[animationComponent.currentFrame];

            animationComponent.currentFrame = animationComponent.currentFrame + 1;

            if (animationComponent.currentFrame > animationComponent.animationSequence.frameIds.length) {
                animationComponent.currentFrame = 0;
            }

            // add the location and frame information to tileData
            tileData.push(locationComponent.xpos);
            tileData.push(locationComponent.ypos);
            tileData.push(frameId);
        }

        tilesheet.drawTiles(graphics, tileData);
    }
}