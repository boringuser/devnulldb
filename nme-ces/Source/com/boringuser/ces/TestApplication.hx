package com.boringuser.ces;

import haxe.Timer;

import nme.Assets;
import nme.display.FPS;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageDisplayState;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.system.Capabilities;

/**
 * Main application class.
 */
class TestApplication implements haxe.rtti.Infos, extends Sprite
{

	// screen resolution
	private var resX : Float;
	private var resY : Float;

	private var simulation : Simulation;

	public function new ()
	{
		super();
		initialize();
	}

	private function determineResolution () : Void
	{
		resX = Lib.current.stage.stageWidth;
		resY = Lib.current.stage.stageHeight;
	}

	private function stage_onResize (event:Event) : Void
	{
		determineResolution();
	}

	private function initialize () : Void
	{
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_BORDER;

		// we'll check resolution now, and then register for Event.RESIZE.
		// on iOS, a resize event can be used to determine the actual resolution.
		// if we check before this event on iOS we might get incorrect values
		// (i.e. shows as portrait when it's really landscape).

		determineResolution();
		Lib.current.stage.addEventListener(Event.RESIZE, stage_onResize);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		// display FPS
		var fps : FPS = new FPS();
		this.addChild(fps);

		// set up simulation, components and systems
		var animationLoader : AnimationLoader = new HardcodedAnimationLoader();

		var animationSystem : AnimationSystem = new AnimationSystem(this.graphics, animationLoader);
		Simulation.addSystem(animationSystem);

		var randomMovementSystem : RandomMovementSystem = new RandomMovementSystem();
		Simulation.addSystem(randomMovementSystem);

		var keyboardInputSystem : KeyboardInputSystem = new KeyboardInputSystem();
		Simulation.addSystem(keyboardInputSystem);

		var keyboardMovementSystem : KeyboardMovementSystem = new KeyboardMovementSystem(keyboardInputSystem);
		Simulation.addSystem(keyboardMovementSystem);

		// create a bunch of entities
		for (i in 0...200) {
			var entityId : String = "entity " + i;
			Simulation.createEntity(entityId);

			var animationComponent : AnimationComponent = new AnimationComponent(animationLoader);
			animationComponent.setAnimationSequenceName("walking");
			Simulation.addComponentToEntity(animationComponent, entityId);

			var locationComponent : LocationComponent = new LocationComponent();
			locationComponent.xpos = Std.random(480);
			locationComponent.ypos = Std.random(320);
			Simulation.addComponentToEntity(locationComponent, entityId);

			if (i == 0) {
				var playerCharacterComponent : PlayerCharacterComponent = new PlayerCharacterComponent();
				Simulation.addComponentToEntity(playerCharacterComponent, entityId);
			}
		}
	}

	function onEnterFrame (event:Event) : Void 
	{
		graphics.clear();
		Simulation.update();
	}

	public static function main ()
	{
		Lib.current.addChild(new TestApplication());
	}

}
