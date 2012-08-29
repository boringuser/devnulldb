
import nme.Assets;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageDisplayState;
import nme.display.StageScaleMode;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;

class Main extends Sprite
{

    private var tilesheet:Tilesheet;
    private var tileData:Array<Float>;
    
    private var lastAnimationTime:Int;
    private var animationFrame:Int;

    public function new ()
    {
        super();
        initialize();
        addSprite();
    }

    public function initialize () : Void
    {
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_BORDER;
        Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN;

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    function onEnterFrame (event:Event) : Void 
    {
        graphics.clear();

        var time = Lib.getTimer();

        if (lastAnimationTime + 500 < time)
        {
            animationFrame = if (animationFrame == 0) 1 else 0;
            lastAnimationTime = time;
        }

        tileData[2] = tileData[5] = animationFrame;

        tilesheet.drawTiles(graphics, tileData);
    }

    private function addSprite () : Void
    {
        tilesheet = new Tilesheet(Assets.getBitmapData("images/Chef.png"));

        tilesheet.addTileRect(new Rectangle(4, 0, 8, 16));
        tilesheet.addTileRect(new Rectangle(20, 0, 8, 16));

        tileData = [10, 10, 0, 20, 10, 0];
    }

    public static function main ()
    {
        Lib.current.addChild(new Main());
    }

}