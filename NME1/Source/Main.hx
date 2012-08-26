
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageDisplayState;
import nme.display.StageScaleMode;
import nme.Lib;

class Main extends Sprite
{

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
    }

    private function addSprite () : Void
    {
        var bitmap = new Bitmap(Assets.getBitmapData("images/Chef.png"));

        addChild(bitmap);
    }

    public static function main ()
    {
        Lib.current.addChild(new Main());
    }

}